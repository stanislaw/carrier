class ExcludeSelfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    recipients = record.send(attribute)
    
    if recipients.include?(record.sender)
      record.errors.add attribute, (options[:messages] || "cannot write to self!")
      recipients.delete(record.sender) 
    end
  end
end
