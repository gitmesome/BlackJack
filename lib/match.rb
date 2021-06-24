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
    calulate_win_rate
    breakdown_wins_by_score
  end

  def show_matches
    @stats.each do |stat|
      puts stat[:hands]
      puts "Winner - #{stat[:result][0] == 'w' ? 'Player' : 'Dealer'}\n\n"
    end
  end

  def calulate_win_rate
    num_of_games = @stats.size
    num_of_player_wins = @stats.select { |s| s[:result][0] == 'w' }.size
    win_rate = (num_of_player_wins.to_f / num_of_games) * 100
    puts "\nPlayer Win Rate: #{num_of_player_wins} / #{num_of_games} = #{format('%.2f', win_rate)}%"
  end

  def breakdown_wins_by_score
    puts "\nPlayer Winning Hand => # of times achieved"
    all_scores = @stats.collect { |s| s[:result] }.zip(@stats.collect { |s| s[:score] }).select { |p| p[0][0] == 'w' }.collect { |m| m[1][0] }
    (all_scores.min..all_scores.max).each do |idx|
      puts "#{idx} => #{all_scores.count(idx)}"
    end
  end
end
