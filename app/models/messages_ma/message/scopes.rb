module MessagesMa
  class Message
    module Scopes
      def self.extended(base)
        base.scope :with, lambda{|user| base.where("\"sender\" = #{user.id} OR \"recipients\" ~ '\\D#{user.id}\\D'") }
        base.scope :by, lambda{|user| base.where("\"sender\" = #{user.id}") }

        base.scope :not_archived_for, lambda{|user| base.where("\"messages_ma_chains\".\"archived_for\" !~ '\\D#{user.id.to_s}\\D'") }
        base.scope :archived_for, lambda{|user| base.where("\"messages_ma_chains\".\"archived_for\" ~ '\\D#{user.id.to_s}\\D'") }

        base.scope :top, lambda{ base.where(:last => true) }
        
        base.scope :with_messages_for, 
          lambda {|user| base
                        .top
                        .with(user)
                        .not_archived_for(user)
                        .joins(:chain)
                 }
        base.scope :with_archived_for,
          lambda {|user| base
                        .top
                        .with(user)
                        .archived_for(user)
                        .joins(:chain)
                 }
        base.scope :unread, lambda {|user| base.with(user).unread_by(user) } 
      
        base.class_eval %{
          def self.sent_by user
            ids = by(user).map{|m| m.chain_id}
            with_messages_for(user).where(:chain_id => ids.uniq)
          end
        }
      end
    end
  end
end
