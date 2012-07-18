module AccountsHelper

  def statistics(data)
    me_words = ["me", "myself", "mine"]
    s = { :favorite => nil, :conversational => nil }
    
    if data["projects"].length
      s[:favorite] = data["projects"].max{|a,b| a["favorited"] <=> b["favorited"] }
      s[:conversational] = data["projects"].max{|a,b| a["comments"] <=> b["comments"] }

      s[:happiness] = Array.new(5) { Array.new }
      s[:gifts] = {:self => 0, :others => 0, :blank => 0, :names => Hash.new(0)}
      data["projects"].each do |project| 
        s[:happiness][project["happiness"].to_i] << project["name"] 
        
        if project["madeFor"]
          if me_words.any?{|word| project["madeFor"].downcase.include? word }
            s[:gifts][:self] += 1
          else
            s[:gifts][:others] += 1
            s[:gifts][:names][project["madeFor"]] += 1
          end
        else
          s[:gifts][:blank] += 1
        end
      end

    end

    s[:names] = ["loser", "unhappy", "meh", "smile", "grin"]
    s[:emoticon_format] = "http://ravelry.com/images/emoticon_%s.png"
    s
  end

  def speed(data)
    s = { :duration => nil, :rate => { :year => nil, :month => nil, :week => nil } }

    if data["projects"].length
      seasons = { :started => Hash.new(0), :completed => Hash.new(0) }
      durations = []
      short = 0
      long = 0
      earliest = Date.today

      data["projects"].select{|p| p["status"] == "finished" and p["completed"] and p["started"]}.each do |project|
        completed = project["completed"].to_date
        started = project["started"].to_date
        
        duration = (completed - started)
        durations << duration.days

        seasons[:started][started.season] += 1
        seasons[:completed][completed.season] += 1

        earliest = started if started < earliest
        


        if ( duration.days < 3.months )
          short += 1
        else
          long += 1
        end
      end

      s[:yearly] = data["projects"].select{|p| p["completed"]}.group_by{|p| p["completed"].to_date.year}

      s[:duration] = durations.mean
      s[:durations] = durations
      s[:seasons] = {}
      seasons.each do |name, counts|
        most = counts.sort{|a,b| b[1]<=>a[1]}.collect{|pair| pair[0].to_s.capitalize}.first(2)
        s[:seasons][name] = most
      end
      s[:seasons][:same] = false
      s[:seasons][:same] = true if s[:seasons][:started].all?{|season| s[:seasons][:completed].include? season}
      s[:short] = short
      s[:long] = long
    end

    s
  end

  def tools(data)
    t = {}
   
    #where my hooks at?

    needles_raw = data["projects"].collect{|p| p["needles"]}
    blank_ratio = needles_raw.select(&:empty?).count / needles_raw.count.to_f
    needles = needles_raw.reject(&:empty?).flatten.uniq.index_by{|needle| needle["metric"]}
    grouped = needles_raw.reject(&:empty?).flatten.group_by{|needle| needle["metric"]}

    favorites = needles.keys.collect{|metric| [metric, grouped[metric].length]}.sort{|a,b| b[1] <=> a[1]}.first(5)
    
    t[:needles] = needles
    t[:blank_ratio] = blank_ratio
    t[:favorites] = favorites
    t
  end
  
  def yarn(data)
    y = {}

    project_yarns = data["projects"].collect{|p| p["yarns"]}
    y[:blank_ratio] = project_yarns.select(&:empty?).count / project_yarns.count.to_f
    y[:yarns] = project_yarns.reject(&:empty?).flatten.uniq.index_by{|yarn| yarn["name"]}
    y[:brands] = project_yarns.reject(&:empty?).flatten.uniq.index_by{|yarn| yarn["brand"]}

    brand_popularity = y[:brands].collect do |(brand,yarn)|
      [brand, data["projects"].select{|p| p["yarns"].include? yarn}.length]
    end
    y[:favorite_brands] = brand_popularity.sort{|a,b| b[1] <=> a[1]}.first(3)

    yarn_popularity = y[:yarns].collect do |(name, yarn)|
      [name, data["projects"].select{|p| p["yarns"].include? yarn}.length]
    end
p yarn_popularity
    y[:favorite_yarn] = yarn_popularity.sort{|a,b| b[1] <=> a[1]}.first

    y
  end
end
