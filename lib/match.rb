# frozen_string_literal: true

require 'player'
require 'dealer'
require 'shoe'
require 'game'

# Class for match actions
class Match
  attr_accessor :shoe, :status

  def initialize
    @shoe = Shoe.new
    @stats = []
    go
    process
  end

  def go
    begin
      loop do
        dealer = Dealer.new(Hand.new)
        players = [Player.new(Hand.new)]
        @stats << Game.new(dealer, players, @shoe).start
      end
    rescue RuntimeError
      puts "All done -- Results follow\n"
    end
  end

  def process
    show_matches
  end

  def show_matches
    @stats.each do |stat|
      puts stat[:hands]
      puts "Winner - #{ stat[:result][0] == 'w' ? 'Player' : 'Dealer'}\n\n"
    end
  end
end
