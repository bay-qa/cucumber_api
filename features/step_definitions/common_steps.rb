Given(/^a "([^"]*)" request is made to "([^"]*)"$/) do |method, path|
  @uri    = URI("http://api.bayqatraining.com#{path}")
  @method = method
end

When(/^these parameters are supplied in URL:$/) do |table|
  @uri.query = URI.encode_www_form(table.rows_hash)
end

Then(/^the api call should (succeed|fail)$/) do |condition|
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

  case condition
    when 'succeed'
      raise 'Request failed, expected success' if !@response.is_a?(Net::HTTPSuccess) || @response.body['Error']
    when 'fail'
      raise 'Request succeeded, expected failure' if @response.is_a?(Net::HTTPSuccess) && !@response.body['Error']
  end
end

And(/^these response keys should have value:$/) do |table|
  @parsed_response = JSON.parse(@response.body)
  table.raw.each do |row|
    expect(@parsed_response[row[0]]).to be == row[1]
  end
end