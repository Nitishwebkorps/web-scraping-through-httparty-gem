
class PagesController < ApplicationController
  def home
    response = HTTParty.get('https://api.publicapis.org/entries')
    @response = JSON.parse(response.body)
    @entries = @response["entries"]
  end

 

end
