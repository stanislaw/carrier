class CreateChains < ActiveRecord::Migration

  def up          
    create_chains
  end

  def down      
    drop_chains
  end

  protected

  def create_chains
    create_table table_name do |t|
      t.string :participants, :default => [].to_yaml 
      t.string :archived_for, :default => [].to_yaml
      t.references :having_chain, :polymorphic => true
      t.string :chain_type, :default => :simple.to_yaml
      t.integer :messages_count, :default => 0
      t.timestamps
    end
    add_index table_name, [:archived_for, :participants], :name => :participants_and_archived_index
    add_index table_name, [:having_chain_id, :having_chain_type], :name => :having_index
    add_index table_name, :created_at
  end

  def drop_chains
    drop_table table_name
  end

  def table_name
    Carrier.config.models.table_for(:chain)
  end
end
