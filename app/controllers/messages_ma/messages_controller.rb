# encoding: UTF-8
module MessagesMa
class MessagesController < ApplicationController
  
  def get_partial
    @render_message = Message.find(params[:message_id])
    @parent_message = Message.find(params[:id])
    @render_message.mark_as_read! :for => current_user if params[:mode]=='full'
    render :update do |page|
      page << "$('#message-#{@render_message.id}').html('#{escape_javascript(render :partial => 'message.html.erb', :locals => {:parent_message => @parent_message, :mode => params[:mode], :message => @render_message })}')"
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
    @message.to = find_to(@re_message, current_user)
  end

  def reply
    prepare_message_for_reply(params[:id])
    render '_reply_form.html.erb' 
  end

  def comment_form
    @report = Report.find(params[:report]) 
    render :update do |page|
      page << "$('#comment_form').html('#{escape_javascript(render :partial => 'reports/reply_form.html.erb')}');"
    end
  end

  def find_to(message, user)
    return ([message.from]+message.to).without(user.id)
  end

  def change_to_many_receivers
    respond_to{|format| format.js}
  end

  def change_to_one_receiver
    respond_to{|format| format.js}
  end

  def archive
    @chains = Chain.archived_for(current_user).page params[:page]
    respond_to do |format|
      format.html { render 'index' }
    end
  end

  def index
    @chains = Chain.with_messages_for(current_user).page params[:page]
    respond_to do |format|
      format.html 
    end
  end

  def sent
    @sent = true
    @chains = Chain.with_messages_sent_by(current_user).page params[:page]
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

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
end
