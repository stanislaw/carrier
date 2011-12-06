class RightRecipientsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    recipients = record.send(attribute)
   
    if recipients.include?(nil)
      record.errors.add :recipients, (options[:message] || I18n.t('activerecord.errors.models.carrier/message.attributes.recipients.wrong'))
      recipients.compact!
    end
  end
end
