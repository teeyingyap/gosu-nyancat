require 'gosu'
require_relative "player"
require_relative "star"
require_relative "animation"

class Game < Gosu::Window

  def initialize
    super 640, 480 #, :fullscreen => true
    self.caption = "Nyan Cat Space Adventure"

    @background_image = Gosu::Image.new("assets/images/space.png", :tileable => true)

    @player_anim = Gosu::Image.load_tiles("assets/images/nyangif2.png", 52, 97)
    @player_array = []
    @player_array.push(Player.new(@player_anim))
    @player_array.each { |play| play.warp(320, 240) }

    @audio = Gosu::Song.new("assets/audio/Nyan Cat.mp3")
    @audio.play
    
    @star_anim = Gosu::Image.load_tiles("assets/images/star.png", 25, 25)
    @stars = Array.new

    @font = Gosu::Font.new(self, "assets/fonts/PressStart2P-Regular.ttf", 20)
    @pause_font = Gosu::Font.new(self, "assets/fonts/PressStart2P-Regular.ttf", 12)
    @pause_counter = 0
  end
  
  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player_array.each { |player| player.turn_left }
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player_array.each { |player| player.turn_right }
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
      @player_array.each { |player| player.accelerate }
    end
    @player_array.each { |player| player.move }
    @player_array.each { |player| player.collect_stars(@stars) }

    if rand(100) < 4 and @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end
  end

  def mute
  	if @pause_counter == 0
  	  @audio.pause
  	  @pause_counter += 1
  	else
      @audio.play
      @pause_counter -= 1
    end
  end 
  
  def draw
  	@background_image.draw(0, 0, ZOrder::BACKGROUND)
    @stars.each { |star| star.draw }
    @player_array.each do |player| 
      player.draw
      @font.draw("Score:#{player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    end
    @pause_font.draw("Click M to mute", 450, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::GRAY)
  end


  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    elsif id == Gosu::KB_M
      self.mute
    else
      super
    end
  end

  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! { |star| Gosu.distance(@x, @y, star.x, star.y) < 35 }
  end
end

Game.new.show



