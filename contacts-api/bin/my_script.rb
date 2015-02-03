require 'addressable/uri'
require 'rest-client'

url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users/1.json'
  # query_values: {
  #   'first_category[cat]' => 'Sennacy',
  #   'second_category[dog]' => 'Rover',
  #   'first_category[bugs][fleas]' => 'Mister Itchy'}
).to_s

user_data = {
  user: {
    name: "Zachary!!!!",
    email: "zachary!!!!!!@gmail.com"
  }
}
puts RestClient.patch(url, user_data)
