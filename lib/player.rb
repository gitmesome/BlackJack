# frozen_string_literal: true

require 'hand'

# Class for player actions
class Player
  # TODO: looks like the '@status' attribute is useless and should be refactored and
  # removed.  This would affect game.rb and associated tests too
  attr_accessor :hand
  attr_reader :status, :standing

  def initialize(hand)
    @hand = hand
    @status = :in
    @standing = :gaming
  end

  def play_status(gaming)
    @status = gaming ? :in : :out
  end

  def standing_set(standing)
    @standing = standing
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

  def hit(card)
    @hand.take(card)
  end

  def score
    @hand.score
  end

  def show_hand
    @hand.show
  end

  def blackjack_twoone_bust_score
    if hit_or_stand? == :stand
      return :blackjack if @hand.score == 21 && @hand.number_of_cards == 2
      return :twoone if @hand.score == 21
      return :bust if @hand.score > 21

      return :stand
    end
    @hand.score
  end
end
