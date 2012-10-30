require 'rspec'
require 'pry'

class Array
  def sum
    self.inject(&:+)
  end
end

class BowlingGame

  def initialize
    @current_frame = nil
    @frames = []
  end

  def roll(pins)
    current_frame.push pins
    if current_frame.sum == 10 || current_frame.size == 2
      @frames << current_frame
      @current_frame = nil
    end
  end

  def score
    @score = 0
    @frames.each_with_index do |frame, index|
      @current_frame_index = index
      @score += frame.sum
      if frame.sum == 10
        frame.size == 1 ? score_strike_bonus : score_spare_bonus
      end
      break if index == 9
    end
    @score   
  end

  def score_spare_bonus
    @score+= next_two_rolls.first unless last_frame
  end

  def score_strike_bonus
    @score+= next_two_rolls.sum unless last_frame
  end

  def last_frame
    @frames[@current_frame_index+1] == nil
  end

  def next_two_rolls
    @frames[(@current_frame_index+1)..-1].flatten[0..1]
  end

  def current_frame
    @current_frame ||= []
  end

end

describe BowlingGame do

  example 'All gutter balls scores 0' do
    game = BowlingGame.new
    20.times { game.roll(0) }
    game.score.should == 0
  end

  example 'All single pin throws scores 20' do
    game = BowlingGame.new
    20.times { game.roll(1) }
    game.score.should == 20
  end

  example 'Throw a spare' do
    game = BowlingGame.new
    2.times { game.roll(5) }
    game.roll(3)
    17.times { game.roll(0) }
    game.score.should == 16
  end

  example 'Throw a strike' do
    game = BowlingGame.new
    game.roll(10)
    game.roll(3)
    game.roll(4)
    17.times { game.roll(0) }
    game.score.should == 24
  end

  example 'Throw a perfect game' do
    game = BowlingGame.new
    12.times { game.roll(10) }
    game.score.should == 300
  end

end