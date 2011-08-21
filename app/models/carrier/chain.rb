# encoding: UTF-8
module Carrier
  class Chain < ActiveRecord::Base

    set_table_name Carrier.config.models.table_for :chain

    serialize :participants, Array
    serialize :archived_for, Array

    paginates_per 25

    has_many :messages, :order => "created_at"

    accepts_nested_attributes_for :messages, :reject_if => proc { |attrs| attrs.all? {|k,v| v.blank?}}

    belongs_to :having_chain, :polymorphic => true

    def last_message
      messages.last
    end
    
    def unarchive!
      unarchive
      self.save!
    end

    def unarchive
      self.archived_for.clear
    end

    def unarchive_for!(user)
      archived_for.delete(user.id)
      save!
    end

    def archive_for!(user)
      self.archived_for = (archived_for << user.id).uniq
      self.save
    end

    def archived_for?(user)
      archived_for.include?(user.id) ? true : false
    end

    def archived_for_any_user?
      archived_for.any? ? true : false 
    end

    def participants_names
      participants.map{|p| User.find(p, :select => "username").username }
    end

    def participants!(participants_arr)
      self.participants = participants_arr | participants
      self.save!
    end

  end
end
