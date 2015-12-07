require 'net/http'
require 'json'
require 'rspec'
require 'benchmark'

$uri_hostname = ENV['HOSTNMAME'] || "http://api.bayqatraining.com"
