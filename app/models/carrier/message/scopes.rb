module Carrier
  class Message
    module Scopes
      def self.extended(base)
        t = Arel::Table.new(base.table_name)
        c = Arel::Table.new(Chain.table_name)
       
        base.scope :for, lambda{|user| base.where(t[:recipients].matches("% #{user.id}\n%")) }
        base.scope :by, lambda{|user| base.where(:sender => user.id) }
        
        base.scope :with, lambda{|user| base.where(t[:sender].eq(user.id).or(t[:recipients].matches("% #{user.id}\n%"))) }

        base.scope :for_index, lambda{|user|
          base.with(user).where("exists(select * from messages m where (m.recipients LIKE '% #{user.id}\n%' AND m.chain_id = messages.chain_id) )")
        }

        base.scope :for_sent, lambda{|user|
          base.with(user).where("exists(select * from messages m where (m.sender = #{user.id} AND m.chain_id = messages.chain_id) )")
        }
       
        base.scope :not_archived_for, lambda { |user| 
            base.where(c[:archived_for].does_not_match("% #{user.id}\n%") ) 
        }

        base.scope :archived_for, lambda { |user| 
            base.where(c[:archived_for].matches("% #{user.id}\n%") ) 
        }

        base.scope :top, lambda{ base.where(:last => true) }

        base.scope :reversed, base.order('messages.created_at DESC')

        base.scope :messages_sent, lambda {|user| base
                                                     .top
                                                     .for_sent(user)
                                                     .not_archived_for(user)
                                                     .includes(:chain)
                                                     .reversed }
       
        base.scope :messages_index, lambda {|user| base
                                                     .top
                                                     .for_index(user)
                                                     .not_archived_for(user)
                                                     .includes(:chain)
                                                     .reversed }

        base.scope :archived_messages_with, lambda {|user| base
                                                     .top
                                                     .with(user)
                                                     .archived_for(user)
                                                     .joins(:chain)
                                                     .reversed }

        base.scope :unread, lambda {|user| base.with(user).unread_by(user) } 
     
      end
    end
  end
end
