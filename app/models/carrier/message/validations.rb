module Carrier
  class Message < ActiveRecord::Base
    validates :sender, :presence => true
    validates :recipients, :recipients_presence => true, :right_recipients => true, :exclude_self => true
    validates :content, :presence => true
  end
end
