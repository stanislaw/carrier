When /^I dump.* the response$/ do
  puts page.body
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^puts me the page$/ do
  puts page.body
end

Then /^debug$/ do
  true
end
