module Carrier
  class Message < ActiveRecord::Base
    validates :sender, :presence => true
    validates :recipients, :recipients_presence => true, :exclude_self => true, :right_recipients => true
    validates :content, :presence => true
  end
end
