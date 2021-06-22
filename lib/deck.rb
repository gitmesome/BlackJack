# frozen_string_literal: true

require 'card'

# Class for handling a deck cards
class Deck
  attr_accessor :deck

  SUITS = %w[Diamonds Hearts Clubs Spades].freeze
  FACES = {
    two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7,
    eight: 8, nine: 9, ten: 10, jack: 10, queen: 10, king: 10, ace: 11
  }.freeze

  def initialize
    @deck = []
    build
  end

  def build
    SUITS.each do |suit|
      FACES.each do |face, value|
        @deck << Card.new(suit, value, face)
      end
    end
  end

  def deal
    @deck.shift unless @deck.empty?
  end

  def shuffle
    @deck = @deck.shuffle
  end

  def size
    @deck.size
  end
end
