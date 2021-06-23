# frozen_string_literal: true

require 'minitest/autorun'
require 'player'
require 'card'

# Test the Deck class
class TestHand < Minitest::Test
  def setup
    @hand = Hand.new
    @card1 = Card.new('Diamonds', 10, :queen)
    @card2 = Card.new('Diamonds', 9, :nine)
    @card3 = Card.new('Diamonds', 11, :ace)
    @card4 = Card.new('Diamonds', 6, :nine)
    @player = Player.new(@hand)
  end

  def test_need_card
    assert_equal(@player.need_card?, true, 'we need a card')
    @player.hand.take(@card1)
    assert_equal(@player.need_card?, true, 'we still need a card')
    @player.hand.take(@card3)
    assert_equal(@player.need_card?, false, 'we dont need any more cards')
  end

  def test_need_card16
    @player.hand.take(@card1)
    @player.hand.take(@card4)
    assert_equal(@player.need_card?, false, 'we dont need any more cards because our score is 16')
  end

  def test_hit_or_stand_stand
    @player.hand.take(@card1)
    @player.hand.take(@card4)
    assert_equal(@player.hit_or_stand?, :stand, 'we should stand because our score is 16')
  end

  def test_hit_or_stand_hit
    @player.hand.take(@card2)
    @player.hand.take(@card4)
    assert_equal(@player.hit_or_stand?, :hit, 'we should hit because our score is 15')
  end

  def test_hit_or_stand_hit_no_hand
    @player.hand.take(@card4)
    assert_equal(@player.hit_or_stand?, :hit, 'we should hit because we need more cards')
  end
end
