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
    @card5 = Card.new('Diamonds', 2, :two)
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

  def test_blackjack_twoone_bust_score_blackjack
    @player.hand.take(@card1)
    @player.hand.take(@card3)
    assert_equal(@player.blackjack_twoone_bust_score, :blackjack, 'we should have a blackjack')
  end

  def test_blackjack_twoone_bust_score_twoone
    @player.hand.take(@card1)
    @player.hand.take(@card2)
    @player.hand.take(@card5)
    assert_equal(@player.blackjack_twoone_bust_score, :twoone, 'we should have 21')
  end

  def test_blackjack_twoone_bust_score_bust
    @player.hand.take(@card1)
    @player.hand.take(@card2)
    @player.hand.take(@card5)
    @player.hand.take(@card3)
    assert_equal(@player.blackjack_twoone_bust_score, :bust, 'we should have 22 busted on the ace')
  end

  def test_blackjack_twoone_bust_score_score
    @player.hand.take(@card1)
    @player.hand.take(@card4)
    assert_equal(@player.blackjack_twoone_bust_score, @player.hand.score, 'we should have a score')
  end

  def test_blackjack_twoone_bust_score_score2
    @player.hand.take(@card1)
    assert_equal(@player.blackjack_twoone_bust_score, @player.hand.score, 'we should have a score with one card')
  end
end
