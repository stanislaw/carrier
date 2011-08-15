require 'singleton'
module Carrier
  class Configuration
    class Models
      include Singleton

      attr_accessor :tables

      def table_for model
        tables[model]
      end

      def tables= hash
        raise "Must be a Hash like {:messages => 'messages'}" if !hash.is_a?(Hash)
        tables.merge! hash
      end
      
      def tables
        @tables ||= default_tables
      end

      def default_tables
        { 
          :message => 'messages', 
          :chain => 'chains'
        }
      end
    end
  end
end

