# frozen_string_literal: true

require 'player'
require 'dealer'
require 'shoe'

# Class for game actions
class Game
  def initialize(dealer, players, shoe)
    @dealer = dealer
    @players = players
    @shoe = shoe
  end

  def start
    first_draw
    unless resolve
      next_player_draw
      next_dealer_draw unless resolve
      resolve
    end
    result
  end

  def first_draw
    2.times do
      @players.each do |player|
        player.hit(@shoe.deal)
      end
      @dealer.hit(@shoe.deal)
    end
  end

  def next_player_draw
    @players.each do |player|
      player.hit(@shoe.deal) while player.hit_or_stand? == :hit
    end
  end

  def next_dealer_draw
    @dealer.hit(@shoe.deal) while @dealer.hit_or_stand? == :hit
  end

  def resolve
    dealer_disposition = @dealer.blackjack_twoone_bust_score
    @players.select { |p| p.status == :in }.each do |player|
      player_disposition = player.blackjack_twoone_bust_score
      case player_disposition
      when :blackjack
        player.play_status(false)
        if dealer_disposition == :blackjack
          player.standing_set(:push) # Dealer has a blackjack too...push
        else
          player.standing_set(:win) # Dealer does not have a blackjack...win
        end
      when :twoone
        case dealer_disposition
        when :twoone
          player.play_status(false)
          player.standing_set(:push) # Delaer does have a 21...push
        when :stand
          player.play_status(false)
          player.standing_set(:win) # Dealer is standing when player has a 21...win
        end
      when :bust
        player.play_status(false)
        player.standing_set(:loss) # Player whent bust
      when :stand
        if dealer_disposition == :stand
          player.play_status(false)
          if @dealer.score < player.score
            player.standing_set(:win) # Player score beats dealer...win
          elsif @dealer.score > player.score
            player.standing_set(:loss) # Player score loses to dealer...loss
          else
            player.standing_set(:push) #Player and Dealer have same score...push
          end
        elsif %i[blackjack twoone].include?(dealer_disposition)
          player.standing_set(:loss) # Player is standing when dealer has blackjack or 21...loss
          player.play_status(false)
        elsif dealer_disposition == :bust
          player.play_status(false)
          player.standing_set(:win) # Dealer is bust while player is standing...win
        else
          player.play_status(true)
          player.standing_set(:gaming)
        end
      end
    end

    if dealer_disposition == :blackjack
      @players.select { |p| p.status == :in }.each do |player|
        player.play_status(false)
        player.standing_set(:loss) # Everybody loses
      end
      true
    else
      return true if @players.select { |p| p.status == :in }.empty?

      false
    end
  end

  def result
    hands = "#{@dealer.class.name} - #{@dealer.show_hand}\n"
    @players.each do |player|
      hands += "#{player.class.name} - #{player.show_hand}\n"
    end
    {
      result: @players.collect { |player| player.standing.to_s[0] },
      score: @players.collect(&:score),
      hands: hands
    }
  end
end
