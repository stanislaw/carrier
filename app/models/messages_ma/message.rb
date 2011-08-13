# encoding: UTF-8
module MessagesMa
  class Message < ActiveRecord::Base
    extend Scopes

    set_table_name "messages_ma_messages"
    paginates_per 25

    serialize :recipients
   
    # Associations
    belongs_to :chain, :counter_cache => true
   
    acts_as_readable :on => :created_at

    # Validations
    validates :sender, :presence => true
    validates :recipients, :presence => true
    validates :content, :presence => true

    before_create do
      self.subject = "(Без темы)" if !subject || subject.empty?
      chain.unarchive! if chain && chain.archived_for_any_user?
      self.last = true
      self.chain = Chain.create if !chain 
    end

    after_create do
      Message.find(@answers_to).clear_last! if @answers_to
      mark_as_read! :for => sender_user
      chain.participants! participants
    end
    # Instance methods

    def answers_to= message
      @answers_to = message
    end
    
    def clear_last!
      self.last = false
      save!
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

    def chain_ub user
      (chain_messages & Message.unread_by(user)).size
    end

    def subject_without_re
      subject.gsub(/re\[\d+\]: /,'')
    end

    def date_formatted
      created_at.strftime('%H:%M %d.%m')
    end

    protected

  end
end
