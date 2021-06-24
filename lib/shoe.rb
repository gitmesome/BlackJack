# frozen_string_literal: true

require 'deck'

# Class for handling a shoe
class Shoe
  attr_accessor :shoe

  def initialize
    @shoe = []
    build
  end

  def build
    6.times do
      deck = Deck.new
      deck.shuffle
      deck.shuffle
      @shoe.push(deck.take_all).flatten!
    end
  end

  def deal
    raise 'Shoe has run out of cards' if @shoe.empty?

    @shoe.shift
  end

  def shuffle
    @shoe = @shoe.shuffle
  end

  def size
    @shoe.size
  end
end
