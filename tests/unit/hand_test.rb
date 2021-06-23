# frozen_string_literal: true

require 'minitest/autorun'
require 'hand'
require 'card'

# Test the Deck class
class TestHand < Minitest::Test
  def setup
    @hand = Hand.new
    @card1 = Card.new('Diamonds', 10, :queen)
    @card2 = Card.new('Diamonds', 9, :nine)
    @card3 = Card.new('Diamonds', 11, :ace)
  end

  def test_take
    @hand.take(@card1)
    assert_equal(@hand.number_of_cards, 1, 'We should onlyhave one card')
    assert_equal(@hand.score, @card1.value, 'Value is wrong for only one card')
  end

  def test_score_over21
    @hand.take(@card1)
    @hand.take(@card2)
    assert_equal(@hand.score, @card1.value + @card2.value, 'Value is wrong for two cards')
    @hand.take(@card3)
    assert_equal(@hand.score, @card1.value + @card2.value + 1, 'Value is wrong for two cards and an ace')
  end

  def test_score_under21
    @hand.take(@card1)
    @hand.take(@card3)
    assert_equal(@hand.score, @card1.value + @card3.value, 'Value is wrong for two cards blackjack')
  end
end
