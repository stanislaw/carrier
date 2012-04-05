# Stolen from Bmabey's database_cleaner gem for educational purposes ;)

module Transaction
  class << self
    def connection_klass
      ActiveRecord::Base
    end

    def start
      if connection_klass.connection.respond_to?(:increment_open_transactions)
        connection_klass.connection.increment_open_transactions
      else
        connection_klass.__send__(:increment_open_transactions)
      end
      connection_klass.connection.begin_db_transaction
    end

    def clean
      return unless connection_klass.connection.open_transactions > 0

      connection_klass.connection.rollback_db_transaction

      if connection_klass.connection.respond_to?(:decrement_open_transactions)
        connection_klass.connection.decrement_open_transactions
      else
        connection_klass.__send__(:decrement_open_transactions)
      end
    end
  end
end
