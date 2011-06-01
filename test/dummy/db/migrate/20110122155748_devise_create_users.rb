class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
#      t.database_authenticatable :null => false
#      t.recoverable
#      t.rememberable
#      t.trackable
      t.string :username
      t.string :name
#      t.string :surname
#      t.string :middlename

#      t.text :about_me
#      t.string :mobile_number
#      t.string :passport
#      t.string :city
#      t.string :real_address

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      # for paperclip's avatar:
#      t.string :avatar_file_name
#      t.string :avatar_content_type
#      t.integer :avatar_file_size
#      t.datetime :avatar_updated_at
      
      t.timestamps
    end

#    add_index :users, :email,                :unique => true
    #add_index :users, :username,             :unique => true
#    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end


  def self.down
    drop_table :users
  end
end
