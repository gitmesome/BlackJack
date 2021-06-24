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
    "#{@face.to_s.capitalize} of #{@suit} (#{@value.to_s.rjust(2)})"
  end

  def to_s
    show
  end
end
