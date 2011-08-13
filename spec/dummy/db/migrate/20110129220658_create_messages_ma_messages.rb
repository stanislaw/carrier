class CreateMessagesMaMessages < ActiveRecord::Migration
  def self.up
    create_table :messages_ma_messages do |t|
      t.integer :sender
      t.string :recipients, :default => [].to_yaml
      t.string :subject
      t.text :content
      
      t.integer :chain_id

      t.boolean :last, :default => false, :null => false

      t.timestamps
    end
    
    add_index :messages_ma_messages, :created_at
    add_index :messages_ma_messages, :chain_id
  end

  def self.down
    drop_table :messages_ma_messages
  end
end
