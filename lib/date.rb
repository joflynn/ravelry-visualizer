class Date

  # close, but not precise
  def season
    case (self + 1.week).month
      when 1..3
        :winter
      when 4..6
        :spring
      when 7..9
        :summer
      when 10..12
        :fall
    end
  end
end
