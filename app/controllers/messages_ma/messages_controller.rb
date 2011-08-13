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
  
  def reply
    @message = Message.new_answer params[:id], current_user
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
    @message.mark_as_read! :for => current_user
    @message_answers = @message.chain.messages.without(@message) 
    respond_to do |format|
      format.html { render :show_as_sent }
    end
  end

  def show
    @message = Message.find(params[:id])
    @chain_archived = @message.chain.archived_for?(current_user)
    @message.mark_as_read! :for => current_user
    @message_answers = @message.chain.messages.without(@message) 
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
