module MessagesMa
  class Message
    module Scopes
      def self.extended(base)
        
        base.scope :with_messages_for, lambda {|user| base.where("\"recipients\" ~ '\\D#{user.id}\\D'").select('messages_ma_messages.id') }
        
        base.scope :unread, lambda {|user| base.with_messages_for(user).unread_by(user)}
        #base.scope :with, lambda {|user| base.where("\"from\" = :from OR (\"recipients\" ~ '\\D#{user.id}\\D')", {:from => user.id }) }
      end
    end
  end
end
