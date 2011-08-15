class RecipientsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    recipients = record.send(attribute)
    
    if recipients.include?(nil)
      record.errors.add attribute, (options[:message] || "check users")
      recipients.compact!   
    end
  end
end
