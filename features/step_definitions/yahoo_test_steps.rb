Given(/^I am on the yahoo page$/) do
  visit(YahooMainPage)
end

When(/^I do search for phrase "([^"]*)"$/) do |search_phrase|
  on(YahooMainPage).search_query = search_phrase
  on(YahooMainPage).do_search
end

Then(/^I should see more then "([^"]*)" result$/) do |arg|
  on(YahooResultsPage).search_results.count.should > arg.to_i
end