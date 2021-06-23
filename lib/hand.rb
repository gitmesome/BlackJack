# frozen_string_literal: true

# Class for handling a hand
class Hand
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def take(card)
    @hand << card
  end

  def number_of_cards
    @hand.size
  end

  def score
    sum = 0
    ace = nil
    hand.each do |card|
      if card.ace?
        ace = card
        next
      end
      sum += card.value
    end
    if ace
      return sum + ace.value if (sum + ace.value) <= 21

      return sum += 1
    end
    sum
  end
end
