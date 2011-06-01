class CreateMessagesMaChains < ActiveRecord::Migration
  class << self

    def up          
      create_chains
    end

    def down      
      drop_chains
    end

    protected

    def create_chains
      create_table :messages_ma_chains do |t|
        t.string :participants, :default => [].to_yaml 
        t.string :archived_for, :default => [].to_yaml
        t.references :having_chain, :polymorphic => true
        t.string :chain_type, :default => :simple.to_yaml
        t.integer :messages_count, :default => 0
        t.timestamps
      end
      add_index :messages_ma_chains, [:archived_for, :participants], :name => :participants_and_archived_index
      add_index :messages_ma_chains, [:having_chain_id, :having_chain_type], :name => :having_index
      add_index :messages_ma_chains, :created_at
    end

    def drop_chains
      drop_table :messages_ma_chains
    end
  end
end
