module MessagesMa
  class Chain 
    module Scopes
      def self.extended(base)
        base.scope :reversed, base.order('created_at DESC')
        base.scope :not_archived_for, lambda{|user| base.where("\"archived_for\" !~ '\\D#{user.id.to_s}\\D'")}
        base.scope :with, lambda{|user| base.where("\"participants\" ~ '\\D#{user.id.to_s}\\D'") }
        base.scope :with_messages_for, lambda{|user| base.reversed.with(user).not_archived_for(user).includes(:messages)}
        base.scope :archived_for, lambda{|user| base.where("\"archived_for\" ~ '\\D#{user.id.to_s}\\D'").reversed}
        base.scope :with_messages_sent_by, lambda{|user| base.where("\"participants\" ~ '^---\\s\\n-\\D#{user.id.to_s}\\D'").reversed }
        base.scope :archived_messages_for, lambda{|user| base.with(user).archived_for(user).includes(:messages) }  
      end
      
      def actual_messages_for(user, limit = nil)
        with_messages_for(user).limit(limit).inject([]){|messages, chain| messages << chain.messages.last }
      end
   
      def archived_messages_for(user, limit = nil)
        archived_messages_for(user).limit(limit).inject([]){|messages, chain| messages << chain.messages.last}
      end

    end
  end
end
