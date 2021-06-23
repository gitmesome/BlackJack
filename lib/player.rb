# frozen_string_literal: true

require 'hand'

# Class for player actions
class Player
  attr_accessor :hand

  def initialize(hand)
    @hand = hand
  end

  def need_card?
    return true if @hand.number_of_cards < 2
    return true if @hand.score < 16

    false
  end

  def hit_or_stand?
    return :hit if need_card?

    :stand
  end

  def blackjack_twoone_bust_score
    if hit_or_stand? == :stand
      return :blackjack if @hand.score == 21 && @hand.number_of_cards == 2
      return :twoone if @hand.score == 21
      return :bust if @hand.score > 21
    end
    @hand.score
  end
end
