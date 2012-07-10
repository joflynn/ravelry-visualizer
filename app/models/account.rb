class Account < ActiveRecord::Base
  @@url_base = "http://api.ravelry.com/projects/joeshmo/progress.json"

  
  attr_accessible :api_key, :username, :data


  def download
    raw_data = RestClient.get @@url_base, {:params => {:key => api_key, :status => "finished" }}

    @data = JSON.parse(raw_data)
  end
end
