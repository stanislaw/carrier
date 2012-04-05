Given /^There is (?:a\s)?(.*)(?:\swith (.*))/ do |resource, params|
 
  # Rails.logger.info "--- #{params}"
  resource = resource.scan(/\w+/).join('_')
  attributes = {}

  begin
    pairs = params.scan(/(\w+)\s"(.*?)"(?:,\s|and\s)?/)
    raise "Somethings wrong with arguments parsing. Check scenarios!" if pairs.any? {|el| el.nil? }
    attributes = Hash[pairs]
  end if params

  res = instance_variable_set :"@#{resource}", singleton(:"#{resource}", attributes)
  # Rails.logger.info("created resource - #{res.inspect}")
end
