# encoding: UTF-8
module MessagesMa
class Chain < ActiveRecord::Base

  serialize :participants, Array
  serialize :archived_for, Array

  paginates_per 25

  has_many :messages, :order => "created_at"

  accepts_nested_attributes_for :messages, :reject_if => proc { |attrs| attrs.all? {|k,v| v.blank?}}

  belongs_to :having_chain, :polymorphic => true

  scope :reversed, order('created_at DESC')
  scope :not_archived_for, lambda{|user| where("\"archived_for\" !~ '\\D#{user.id.to_s}\\D'")}
  scope :with, lambda{|user| where("\"participants\" ~ '\\D#{user.id.to_s}\\D'") }
  scope :with_messages_for, lambda{|user| reversed.with(user).not_archived_for(user).includes(:messages)}
  scope :archived_for, lambda{|user| where("\"archived_for\" ~ '\\D#{user.id.to_s}\\D'").reversed}
  scope :with_messages_sent_by, lambda{|user| where("\"participants\" ~ '^---\\s\\n-\\D#{user.id.to_s}\\D'").reversed }
  scope :archived_messages_for, lambda{|user| with(user).archived_for(user).includes(:messages) }  
  def last_message
    messages.last
  end
  
  def about?
    having_chain.present?
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

  def inject_participants!(participants_arr)
    self.participants = (participants_arr + participants).uniq
    self.save!
  end
end
end
