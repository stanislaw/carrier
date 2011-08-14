# encoding: UTF-8
module MessagesMa
  class Message < ActiveRecord::Base
    extend Scopes
    include Subject

    set_table_name "messages_ma_messages"
    serialize :recipients
    paginates_per 25
  
    attr_accessor :answers_to

    # Associations
    belongs_to :chain, :counter_cache => true
    delegate :archived_for?, :to => :chain
    
    acts_as_readable :on => :created_at

    # Validations
    validates :sender, :presence => true
    validates :recipients, :presence => true
    validates :content, :presence => true

    before_create do
      default_subject!
      chain.unarchive! if chain && chain.archived_for_any_user?
      self.last = true
      self.chain = Chain.create if !chain 
    end

    after_create do
      Message.find(@answers_to).clear_last! if @answers_to
      mark_as_read! :for => sender_user
      chain.participants! participants
    end
    
    def self.new_answer id, user 
      in_answer_to = find(id)
      new_message = self.new

      new_message.sender = user.id
      new_message.recipients = find_recipients in_answer_to, user
      new_message.subject = re in_answer_to.subject
      new_message.chain_id = in_answer_to.chain_id
      new_message.answers_to = in_answer_to.id
      new_message
    end
 
    def self.find_recipients message, user
      ([message.sender] + message.recipients).without(user.id)
    end

    def & messages
      messages & chain.messages
    end
    
    def answers
      chain.messages.without self
    end

    def clear_last!
      self.last = false
      save!
    end

    def default_subject!
      self.subject = I18n.t 'models.simple_messages.no_subject' if !subject || subject.empty?
    end

    def sender_user
      User.find(sender, :select => 'id, username')
    end

    def sender_name
      sender_user.username
    end

    def recipients_names
      recipients.collect{|id| User.find(id, :select => "username").username}.join(', ') #
    end

    def recipients_ids
      recipients
    end

    def recipients_ids= ra
      self.recipients = ra.scan(/\w+/).map(&:to_i)
    end

    def recipients_names= recipients_array
      self.recipients = recipients_array
                       .scan(/\w+/)
                       .map{|name| User.find_by_username(name).id}
                       .compact
                       .uniq
    rescue 
      errors.add(:to, "Check usernames you entered")
    end

    def participants
      [] | recipients << sender
    end
    
    def chain_messages
      chain.messages
    end

    def chain_messages_ub user
      (chain_messages & Message.unread(user)).size
    end

    def date_formatted
      created_at.strftime('%H:%M %d.%m')
    end

    protected

  end
end
