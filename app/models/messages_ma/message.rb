# encoding: UTF-8
module MessagesMa
  class Message < ActiveRecord::Base
    set_table_name "messages_ma_messages"
    paginates_per 25

    serialize :to
    
    # Associations
    belongs_to :chain, :counter_cache => true
   
    # Scopes
    scope :with_messages_for, lambda {|user| where("\"to\" ~ '\\D#{user.id}\\D'").select('messages_ma_messages.id') }
    scope :with, lambda {|user| where("\"from\" = :from OR (\"to\" ~ '\\D#{user.id}\\D')", {:from => user.id }) }
    acts_as_readable :on => :created_at

    # Validations
    validates :from, :presence => true
    validates :to, :presence => true
    validates :content, :presence => true
   
    before_save do
      self.subject = "(Без темы)" if !subject || subject.empty?
      if @answers_to 
        re_chain = self.class.find(@answers_to).chain
        self.chain = re_chain
        re_chain.unarchive! if re_chain.archived_for_any_user?
      else
        self.chain = Chain.create unless chain
      end
    end

    after_save do
      mark_as_read! :for => sender_as_user
      chain.inject_participants!(chain_participants)
    end

    # Лучшая
    def self.actual_messages_for(user, limit = nil)
      Chain.with_messages_for(user).limit(limit).inject([]){|messages, chain| messages << chain.messages.last }
    end
   
    def self.archived_messages_for(user, limit = nil)
      Chain.archived_messages_for(user).limit(limit).inject([]){|messages, chain| messages << chain.messages.last}
    end

    # Instance methods

    def sender_as_user
      User.find(self.from, :select => 'id')
    end
    
    def recipients_ids
      to
    end

    def recipients_names
      recipients_ids.collect{|id| User.find(id, :select => "username").username}.join(', ') #
    end

    def recipients_ids=(recipients_array)
      if recipients_array.class==String
        self.to = recipients_array.scan(/\d+/)
        return
      end
      self.to = recipients_array.uniq
    end

    def recipients_names=(recipients_array)
      self.to = recipients_array
               .scan(/\w+/)
               .map{|name| User.find_by_username(name).id || nil}
               .compact
               .uniq
      logger.info("---------- #{self.to}")
    rescue 
      errors.add(:to, "Check usernames you entered")
    end

    def from_name
      User.find(self.from, :select => 'username').username
    rescue
      raise "Error when retrieving such user!"
    end

    def to=(_to)
      if _to.class==String
        self.to = _to.scan(/\d+/).map{|t| t.to_i}
        return
      end
      super
    end

    def chain_participants
      return ([from]+to).uniq
    end
    
    def chain_messages
      chain.messages
    end

    def chain_collection_unread_by(user)
      (chain_messages & Message.unread_by(user)).size
    end

    def set_answers_to=(answers_to_id)
      @answers_to = answers_to_id
    end

    def no_re_subject
      subject.gsub(/re\[\d+\]: /,'')
    end

    protected

  end
end
