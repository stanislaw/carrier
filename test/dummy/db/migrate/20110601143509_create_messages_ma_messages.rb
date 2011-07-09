class CreateMessagesMaMessages < ActiveRecord::Migration
  def self.up
    create_table :messages_ma_messages do |t|
      t.integer :from
      t.string :to, :default => [].to_yaml
      t.string :subject
      t.string :message_type
      t.text :content
      t.timestamps
      t.integer :chain_id
    end
    add_index :messages_ma_messages, :created_at
    add_index :messages_ma_messages, :chain_id
  end

  def self.down
    drop_table :messages_ma_messages
  end
end
