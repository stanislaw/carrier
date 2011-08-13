# encoding: UTF-8
module MessagesMa
class MessagesController < ApplicationController
  
  def get_partial
    @render_message = Message.find(params[:message_id])
    @parent_message = Message.find(params[:id])
    @render_message.mark_as_read! :for => current_user if params[:mode]=='full'
    respond_to do |format|
      format.js  
    end
  end
  
  def reply_form
    prepare_message_for_reply(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def get_re(name)
    if name.match(/re/).nil?
      return "re: "+name
    elsif !name.match(/re:/).nil?
      return name.sub(/re:/,'re[2]:')
    elsif name.match(/re\[\d+\]/)
      @re_count = name.match(/re\[\d+\]:/)[0].match(/\d+/)[0]
      @re_count = @re_count.to_i + 1
      return name.sub(/re\[\d+\]/, 're['+@re_count.to_s+']')
    end
    return name
  end

  def prepare_message_for_reply(params)
    @re_message = Message.find(params.to_i)
    @message = Message.new
    @message.subject = get_re(@re_message.subject)
    @message.recipients = find_recipients(@re_message, current_user)
    @message.chain_id = @re_message.chain_id
  end

  def reply
    prepare_message_for_reply(params[:id])
    render '_reply_form.html.erb' 
  end

  def find_recipients(message, user)
    return ([message.sender] + message.recipients).without(user.id)
  end

  def archive
    @messages = Message.with_archived_for(current_user).page params[:page]
    respond_to do |format|
      format.html { render 'index' }
    end
  end

  def index
    @messages = Message.with_messages_for(current_user).page params[:page]
  end

  def sent
    @sent = true
    @messages = Message.sent_by(current_user).page params[:page]
    respond_to do |format|
      format.html { render 'index' } 
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  
  def as_sent
    @message = Message.find(params[:id], :include => :chain)
    @last_message = @message.chain.messages.last
    unless @last_message==@message
      redirect_to message_path(@last_message)
      return
    end
    @message.mark_as_read! :for => current_user
    @message_answers = @message.chain.messages.without(@message) 
    respond_to do |format|
      format.html { render :show_as_sent }
      format.xml  { render :xml => @message }
    end
  end

  def show
    @message = Message.find(params[:id])
    @chain_archived = @message.chain.archived_for?(current_user)
    @last_message = @message.chain.messages.last
    unless @last_message==@message
      redirect_to message_path(@last_message)
      return
    end
    @message.mark_as_read! :for => current_user
    @message_answers = @message.chain.messages.without(@message) 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = MessagesMa::Message.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    respond_to do |format|
      if @message.save
        format.html { redirect_to(@message, :notice => 'Сообщение создано') }
        format.js
      else
        format.js {
          if re_m = params[:message][:set_answers_to]
            @re_message = Message.find(re_m.to_i)
          end
          render :action => "new"
        }
        format.html { render :action => "new" }
      end
    end
  end

end
end
