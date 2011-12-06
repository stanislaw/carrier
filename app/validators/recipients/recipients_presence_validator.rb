class RecipientsPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    recipients = record.send(attribute)
   
    record.errors.add :recipients, (options[:message] || I18n.t('activerecord.errors.models.carrier/message.attributes.recipients.empty')) if recipients.empty?

  end
end
