Given(/^a "([^"]*)" request is made to "([^"]*)"$/) do |method, path|
  # substitutes <id> (or any other keyword in angle brackets) in path with saved value, used for passing dynamic parameters
  if path.include?('<')
    path.gsub!(/<.*>/, $value.to_s)
  end
  # constructs URI with endpoint i.e http://api.bayqatraining.com/user
  @uri    = URI("#{$uri_hostname}#{path}")
  # @method is a variable that reference to the verb (i.e GET, POST)
  @method = method
end

When(/^these parameters are supplied in (URL|body):$/) do |condition, table|
  if condition == 'URL'
    # flattens table parameters from feature file
    # into URI format i.e email=andrei9%40gmail.com&password=secret
    @uri.query = URI.encode_www_form(table.rows_hash)
  else
    # saves JSON to instance variable
    @body = table.raw[0][0]
  end
end

Then(/^the api call should (succeed|fail)$/) do |condition|
  # picks which http verb to use bases on @method variable value
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

  # start method immediately creates a connection to an HTTP server
  # which is kept open for the duration of the block
  Net::HTTP.start(@uri.host, @uri.port) do |http|
    # line 41 declares variable request and constructs HTTP object using method from case statement above, example:
    # Net::HTTP::Get.new(http://api.bayqatraining.com/login?email=andrei9%40gmail.com&password=secret)
    request = method.new(@uri)
    puts "Request method: #{@method.upcase}"
    puts "Request URI: #{@uri}"

    # sets request cookies to value from global variable if it's not nil
    if $cookies
      puts "Request cookies: #{$cookies}"
      request['Cookie'] = $cookies
    end

    # sets request body and content type if body is not nil
    if @body
      puts "Request body: #{@body}"
      request.body = @body
      request.set_content_type('application/json')
    end

    # 'http.request request' makes request, then saves response in instance variable, also measures response time
    response_time = Benchmark.realtime { @response = http.request request }
    puts "Response status: #{@response.code} #{@response.message}"
    puts "Response time: #{response_time}"

    # saves cookies from response in global variable
    if @response['Set-cookie']
      $cookies = @response['Set-cookie']
      puts "Response Cookies: #{$cookies}"
    end
  end
  puts "Response body: #{@response.body}"

  # saves parsed response in instance variable
  @parsed_response = JSON.parse(@response.body)

  # value of condition variable can be only succeed or failed which we specify in feature file
  case condition
    when 'succeed'
      # raises error message in terminal if response has error and response is NOT successful
      if !@response.is_a?(Net::HTTPSuccess) || @response.body['Error']
        raise 'Request failed, expected success'
      end
    when 'fail'
      # raises error message in terminal if response does NOT have error and response IS successful
      if @response.is_a?(Net::HTTPSuccess) && !@response.body['Error']
        raise 'Request succeeded, expected failure'
      end
  end
end

And(/^these response keys should have value:$/) do |table|
  # Parse the JSON document _source_ into a Ruby HashMap data structure and return it
  # i.e table = {"id"=>108, "name"=>"Andrei", "email"=>"andrei9@gmail.com"}
  table.raw.each do |row|
    # go through each row in table from feature file
    # match that first row from server response is equal to first row from table in feature file
    # name"=>"Andrei" == "name", "Andrei"
    expect(@parsed_response[row[0]]).to be == row[1]
  end
end

And(/^value of "([^"]*)" is saved in a global variable$/) do |key|
  $value = @parsed_response[key]
  puts "Saved value of #{key}: #{$value}"
end











