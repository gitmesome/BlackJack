# frozen_string_literal: true
#
# require 'player'

# Class for game actions
class Game
  def initialize(dealer, players, shoe)
    @dealer = dealer
    @players = players
    @shoe = shoe
  end

  def draw
    @players.each do |player|
      player.hit(@shoe.deal) while player.hit_or_stand? == :hit
    end

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
          player.standing_set(:push)
        else
          player.standing_set(:win)
        end
      when :twoone
        case dealer_disposition
        when :twoone
          player.play_status(false)
          player.standing_set(:push)
        when :stand
          player.play_status(false)
          player.standing_set(:win)
        end
      when :bust
        player.play_status(false)
        player.standing_set(:loss)
      when :stand
        if dealer_disposition == :stand
          player.play_status(false)
          if @dealer.score < player.score
            player.standing_set(:win)
          elsif @dealer.score > player.score
            player.standing_set(:loss)
          else
            player.standing_set(:push)
          end
        elsif %i[blackjack twoone].include?(dealer_disposition)
          player.standing_set(:loss)
          player.play_status(false)
        else
          player.play_status(true)
          player.standing_set(:playing)
        end
      end
    end
  end

  def result
    @players.collect { |player| player.standing.to_s[0] }
  end
end
