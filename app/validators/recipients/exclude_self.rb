class ExcludeSelfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    recipients = record.send(attribute)
    
    if recipients.include?(record.sender)
      record.errors.add :recipients, (options[:message] || t('activerecord.errors.models.carrier/message.attributes.recipients.cannot_write_to_self') )
      recipients.delete(record.sender) 
    end
  end
end
