class CreateMessages < ActiveRecord::Migration
  def up
    create_table table_name do |t|
      t.integer :sender
      t.string :recipients, :default => [].to_yaml
      t.string :subject
      t.text :content
      
      t.boolean :last, :default => false, :null => :false

      t.integer :chain_id
 
      t.timestamps
    end
    add_index table_name, :created_at
    add_index table_name, :chain_id
  end

  def down
    drop_table table_name
  end

  def table_name
    Carrier.config.models.table_for(:message)
  end
end
