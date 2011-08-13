module MessagesMa
  class Message < ActiveRecord::Base
    module Subject
      
      module ClassMethods
        def re name
          if name.match(/re/).nil?
            return "re: "+name
          elsif !name.match(/re:/).nil?
            return name.sub(/re:/,'re[2]:')
          elsif name.match(/re\[\d+\]/)
            @re_count = name.match(/re\[\d+\]:/)[0].match(/\d+/)[0]
            @re_count = @re_count.to_i + 1
            return name.sub(/re\[\d+\]/, 're['+@re_count.to_s+']')
          end
          name
        end
      end

      def self.included base
        base.extend ClassMethods
      end

      def subject_without_re
        subject.gsub(/re\[\d+\]: /,'')
      end

    end
  end
end
   

