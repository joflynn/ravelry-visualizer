class Ball
  SIZES = ["small", "medium", "large"].freeze
  WEIGHTS= ["sock", "aran", "bulky"].freeze
  COLORS = ["yellow-orange", "yellow-green", "yellow", "white", "red-purple", "red-orange", "red", "purple", "pink", "orange", "natural", "green", "gray", "brown", "blue-green", "blue"].freeze
  ROTATIONS = (0..360).to_a.freeze
  Z_INDICIES = (6..9).to_a.freeze

  @@last_position = [0, 0]

  def initialize
    @size = Ball::SIZES.sample
    @weight = Ball::WEIGHTS.sample
    @color = Ball::COLORS.sample
    @rotation = Ball::ROTATIONS.sample
    @position = Array.new(Ball.next_position)
    @z_index = Ball::Z_INDICIES.sample
  end

  def to_s
    "<img class='ball #{@size}' src='#{src}' style='#{style}' data-x='#{@position[1]}' />".html_safe
  end

  def src
    "/yarn-%s-%s.png" % [@weight, @color]
  end

  def style
    bottom = 40 * @position[0]
    left = -40 + 20 * @position[1] 

    [ "bottom: %spx" % bottom,
      "left: %spx" % left, 
      "z-index: %s" % @z_index,
      "-webkit-transform: rotate(%ddeg)" % @rotation,
      "-moz-transform: rotate(%ddeg)" % @rotation, 
      "-ms-transform: rotate(%ddeg)" % @rotation, 
      "-o-transform: rotate(%ddeg)" % @rotation, 
      "transform: rotate(%ddeg)" % @rotation 
    ].join("; ")
  end

  def self.next_position
    @@last_position[0] = (@@last_position[0] + 1) % 2
    @@last_position[1] += 1
    @@last_position
  end

  def self.reset
    @@last_position = [0, 0]
  end

  def self.generate(num)
    return if num < 0
    
    @@last_position = [0, 0]
    num.to_i.times.collect{ Ball.new }
  end
end
