Given(/^a "([^"]*)" request is made to "([^"]*)"$/) do |method, path|
  @uri    = URI("http://api.bayqatraining.com#{path}")
  @method = method
end

When(/^these parameters are supplied in URL:$/) do |table|
  @uri.query = URI.encode_www_form(table.rows_hash)
end

Then(/^the api call should succeed$/) do
  case @method.downcase
    when 'get'
      method = Net::HTTP::Get
    when 'post'
      method = Net::HTTP::Post
    when 'put'
      method = Net::HTTP::Put
    when 'delete'
      method = Net::HTTP::Delete
  end

  Net::HTTP.start(@uri.host, @uri.port) do |http|
    request   = method.new(@uri)
    @response = http.request request
  end
  puts @response.body
end
