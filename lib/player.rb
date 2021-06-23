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
end
