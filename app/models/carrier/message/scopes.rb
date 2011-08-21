module Carrier
  class Message < ActiveRecord::Base
    
    t = Arel::Table.new(table_name)
    c = Arel::Table.new(Chain.table_name)
   
    scope :for, lambda{|user| where(t[:recipients].matches("% #{user.id}\n%")) }
    scope :by, lambda{|user| where(:sender => user.id) }
    
    scope :with, lambda{|user| where(t[:sender].eq(user.id).or(t[:recipients].matches("% #{user.id}\n%"))) }

    scope :for_index, lambda{|user|
      with(user).where("exists(select * from messages m where (m.recipients LIKE '% #{user.id}\n%' AND m.chain_id = messages.chain_id) )")
    }

    scope :for_sent, lambda{|user|
      with(user).where("exists(select * from messages m where (m.sender = #{user.id} AND m.chain_id = messages.chain_id) )")
    }
   
    scope :not_archived_for, lambda { |user| 
      where(c[:archived_for].does_not_match("% #{user.id}\n%") ) 
    }

    scope :archived_for, lambda {|user| where(c[:archived_for].matches("% #{user.id}\n%")) }

    scope :top, lambda{ where(:last => true) }

    scope :reversed, order('messages.created_at DESC')

    scope :messages_sent, lambda {|user| top
                                         .for_sent(user)
                                         .not_archived_for(user)
                                         .includes(:chain)
                                         .reversed }
   
    scope :messages_index, lambda {|user| top
                                         .for_index(user)
                                         .not_archived_for(user)
                                         .includes(:chain)
                                         .reversed }

    scope :archived_messages_with, lambda {|user| top
                                                 .with(user)
                                                 .archived_for(user)
                                                 .joins(:chain)
                                                 .reversed }

    scope :unread, lambda {|user| with(user).unread_by(user) } 
   
  end
end
