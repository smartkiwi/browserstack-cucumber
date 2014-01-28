class YahooMainPage
  include PageObject

  page_url 'http://yahoo.com'


  text_field(:search_query, name: 'p')

  button(:do_search, id: 'search-submit')

end