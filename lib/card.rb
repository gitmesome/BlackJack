# frozen_string_literal: true

# Class for handling individual cards
class Card
  attr_accessor :suit, :value, :face

  def initialize(suit, value, face)
    @suit = suit
    @value = value
    @face = face
  end

  def ace?
    return true if @face == :ace

    false
  end

  def show
    "#{@value.to_s.ljust(3)} of #{@suit} with a face of #{@face}"
  end

  def to_s
    show
  end
end
