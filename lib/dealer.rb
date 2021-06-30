# frozen_string_literal: true

require 'player'

# Class for dealer actions
class Dealer < Player

  def need_card?
    return true if @hand.number_of_cards < 2
    return true if @hand.score < 17

    false
  end
end
