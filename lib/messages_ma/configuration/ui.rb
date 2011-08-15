require 'singleton'
module Carrier
  class Configuration
    class UI
      include Singleton

      def set style = :simple
        @state = style
      end

      def style
        @state || default
      end

      def default
        :simple
      end

      [:simple, :rich].each do |type|
        define_method(:"#{type}?") do
          @state == type
        end
      end
 
    end
  end
end

