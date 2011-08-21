module Carrier
  class Message < ActiveRecord::Base
    validates :sender, :presence => true
    validates :recipients, :presence => true, :recipients => true, :exclude_self => true
    validates :content, :presence => true
  end
end
