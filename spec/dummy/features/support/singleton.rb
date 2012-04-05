module SingletonHelper
  def singleton name, *options
    @@singletons ||= {}
    
    begin 
      @@singletons[name].reload
    
    rescue NoMethodError, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      # puts "singleton error (#{e.class}): " << e.message
      @@singletons[name] ||= create name, *options
    end
  end

  def reset_singletons!
    @@singletons = {}
  end
end
