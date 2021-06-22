# frozen_string_literal: true

require 'minitest/autorun'
require 'deck'

# Test the Deck class
class TestDeck < Minitest::Test
  def setup
    @deck = Deck.new
  end

  def test_deck_size
    assert_equal(52, @deck.size, 'Wrong deck size')
  end

  def test_deal
    card = @deck.deal
    assert_equal(card.suit, Deck::SUITS[0], 'Card should be of correct suit')
    assert_equal(51, @deck.size, 'Wrong deck size')
    52.times { card = @deck.deal }
    assert_equal(card, nil, 'No more cards left in the deck')
  end
end
