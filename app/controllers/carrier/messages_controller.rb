# encoding: UTF-8

module Carrier
  class MessagesController < ApplicationController
    
    after_filter :only => [:as_sent, :show] { @message.mark_as_read! :for => current_user }
    
    [:collapsed, :expanded].each do |mode|
      define_method(mode) do 
        @message = Message.find(params[:id])
        @message.mark_as_read! :for => current_user if mode == :expanded
      end
    end

    def reply
      @message = Message.new_answer params[:id], current_user
    end

    def archive
      @messages = Message.archived_messages_with(current_user).page params[:page]
      render 'index'
    end

    def index
      @messages = Message.messages_index(current_user).page params[:page]
    end

    def sent
      @messages = Message.messages_sent(current_user).page params[:page]
      render 'index'
    end

    def as_sent
      @message = Message.find(params[:id], :include => :chain)
    end

    def show
      @message = Message.find(params[:id], :include => :chain)
    end

    # TODO: introduce [:id or :username] key to be passed with to= param
    def new
      @message = Message.new
      @message.recipients_names = params[:to] if params[:to]
    end

    def create
      @message = Message.new(params[:message])
      respond_to do |format|
        if @message.save
          format.html { redirect_to(as_sent_message_path(@message), :notice => t('views.carrier.successfully_created')) }
          format.js
        else
          format.js { render :action => "new" }
          format.html { render :action => "new" }
        end
      end
    end
  
  end
end
