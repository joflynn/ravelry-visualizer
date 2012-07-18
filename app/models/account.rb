class Account < ActiveRecord::Base
  @@url_base_format = "http://api.ravelry.com/projects/%s/progress.json"
  @@cache_expiration = 1.day
  @@cache_dir = "tmp/ravelry"
  
  attr_accessible :api_key, :username
  attr_accessor :data
  after_initialize :pull
  validate :ravelry_authenticates, :on => :create


  def pull
    unless username.nil?
      load_cache
      if @data.nil?
        begin
          raw_data = RestClient.get @@url_base_format % username, {:params => {:key => api_key, :status => "finished" }}
        
          @data = JSON.parse(raw_data)
p @data
        rescue
        end
          
        save_cache
      end
      @data
    end
  end

  def pronouns
    if username == "joeshmo"
      {:i => "I", :me => "me", :mine => "mine", :my => "my", :myself => "myself"}
    else
      {:i => "you", :me => "you", :mine => "your", :my => "your",  :myself => "yourself"}
    end
  end

  def visitor?
    username != "joeshmo"
  end

  def invalid_api_key
    errors[:base] << "API key incorrect"
  end
  protected

  #disabled caching.  Heroku does not seem to want me writing files in /tmp

  def load_cache
    return false

    if File.exists?(cache_filename)
      File.open(cache_filename, "r") do |f|
        save_date = f.readline.to_datetime
        if ( save_date + @@cache_expiration > DateTime.now )
          @data = JSON.parse(f.readline)
        end
      end
    end
  end

  def save_cache
    return false

    unless @data.nil?
      File.open(cache_filename, "w") do |f|
        f.puts(DateTime.now)
        f.puts(JSON.generate(@data))
      end
    end
  end

  def cache_filename
    "#{@@cache_dir}/#{api_key}"
  end

  def ravelry_authenticates
    pull
    errors[:base] << "Username and API key don't match." if @data.nil?
  end

end
