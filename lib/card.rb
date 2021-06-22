# frozen_string_literal: true

# Class for handling individual cards
class Card
  attr_accessor :suit, :value, :face

  def initialize(suit, value, face)
    @suit = suit
    @value = value
    @face = face
  end

  def show
    msg = "#{@face.ljust(8)} of #{@suit}"
    puts msg
    msg
  end
end
