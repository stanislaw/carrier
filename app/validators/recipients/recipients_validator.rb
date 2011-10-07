class RecipientsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    recipients = record.send(attribute)
    
    if recipients.include?(nil)
      record.errors.add attribute, (options[:message] || I18n.t('activerecord.errors.models.carrier/message.attributes.recipients.wrong'))
      recipients.compact!   
    end
  end
end
