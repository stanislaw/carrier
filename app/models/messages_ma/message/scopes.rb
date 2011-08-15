module MessagesMa
  class Message
    module Scopes
      def self.extended(base)
        t = Arel::Table.new(base.table_name)
        c = Arel::Table.new(Chain.table_name)

        base.scope :with, lambda{|user| base.where(t[:sender].eq(user.id).or(t[:recipients].matches("% #{user.id}\n%"))) }

        base.scope :for, lambda{|user| base.where(t[:recipients].matches("% #{user.id}\n%")) }

        base.scope :by, lambda{|user| base.where(:sender => user.id) }
        
        base.scope :not_archived_for, lambda { |user| 
            base.joins(:chain).where(c[:archived_for].does_not_match("% #{user.id}\n%") ) 
        }

        base.scope :archived_for, lambda { |user| 
            base.joins(:chain).where(c[:archived_for].matches("% #{user.id}\n%") ) 
        }

        base.scope :top, lambda{ base.where(:last => true) }
 
        base.scope :messages_with, lambda {|user| base
                                                     .top
                                                     .with(user)
                                                     .not_archived_for(user)
                                                     .joins(:chain) }
       
        base.scope :messages_for, lambda {|user| base
                                                     .top
                                                     .for(user)
                                                     .not_archived_for(user)
                                                     .joins(:chain) }
        base.scope :archived_messages_with, lambda {|user| base
                                                     .top
                                                     .with(user)
                                                     .archived_for(user)
                                                     .joins(:chain) }
        base.scope :unread, lambda {|user| base.with(user).unread_by(user) } 
     
        # How to accomplish this in one query, using scope?
        base.define_singleton_method :messages_sent_by do |user|
          ids = by(user).map{|m| m.chain_id}
          messages_with(user).where(:chain_id => ids.uniq)
        end
      end
    end
  end
end
