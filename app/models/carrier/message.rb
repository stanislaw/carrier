# encoding: UTF-8
module Carrier
  class Message < ActiveRecord::Base
    self.table_name = Carrier.config.models.table_for :message
    
    concerned_with :scopes, :subject, :validations

    serialize :recipients, Array
    paginates_per 25
  
    belongs_to :chain, :counter_cache => true, :class_name => "Carrier::Chain"
    
    delegate :messages, :to => :chain, :prefix => true
    delegate :archived_for?, :archived_for_any_user?, :participants!, :to => :chain
    
    belongs_to :sender_user, :foreign_key => "sender", :class_name => "User"

    acts_as_readable :on => :created_at

    attr_accessor :answers_to

    before_create do
      default_subject!
      make_last
      chain.unarchive! if chain_archived?
      chain!
    end

    after_create do
      Message.find(answers_to).clear_last! if answers_to
      mark_as_read! :for => sender_user
      participants! participants
    end
    
    class << self
      def new_answer id, user 
        in_answer_to = find id
        new :sender     => user.id,
            :recipients => find_recipients(in_answer_to, user),
            :subject    => in_answer_to.subject,
            :chain_id   => in_answer_to.chain_id,
            :answers_to => in_answer_to.id
      end
 
      def find_recipients message, user
        ([message.sender] + message.recipients).without(user.id)
      end
    end

    def mark_chain_as_read_for user
      chain_messages.each do |message|
        message.mark_as_read! :for => user
      end
    end

    def chain_archived?
      chain && archived_for_any_user?
    end

    def make_last
      self.last = true
    end

    def & messages
      messages & chain_messages
    end
    
    def answers
      chain_messages.without self
    end

    def clear_last!
      self.last = false
      save!
    end

    def default_subject!
      self.subject = I18n.t('models.carrier.no_subject') if !subject || subject.empty?
    end

    def sender_name
      sender_user.username
    end

    def recipients_ids
      recipients
    end

    def recipients_ids= ra
      self.recipients = ra.scan(/\d+/).map(&:to_i)
    end

    def recipients= r_arr
      super r_arr.without("").map(&:to_i)
    end

    def recipients_names
      User.where(:id => recipients).pluck(:username).join(', ')
    end

    def recipients_names= recipients_array
      self.recipients = recipients_array.scan(/\w+/).map do |name| 
        begin 
          User.find_by_username!(name).id
        rescue
          nil
        end
      end.uniq
    end

    def participants
      (recipients + [sender]).compact
    end
    
    def date_formatted
      created_at.strftime('%H:%M %d.%m')
    end

    private

    def chain!
      self.chain = Carrier::Chain.create if !chain 
    end

  end
end
