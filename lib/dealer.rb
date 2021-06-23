# frozen_string_literal: true

require 'player'

# Class for dealer actions
class Dealer < Player
  def show_hand
    @hand.hand[0].to_s
  end
end
