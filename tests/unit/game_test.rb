# frozen_string_literal: true

require 'minitest/autorun'
require 'game'
require 'dealer'
require 'shoe'
require 'player'

# Test the Game class
class TestGame < Minitest::Test
  def setup
    @dealer = Dealer.new(Hand.new)
    @players = [Player.new(Hand.new), Player.new(Hand.new)]
    @shoe = Shoe.new
    @card1 = Card.new('Diamonds', 10, :queen)
    @card2 = Card.new('Diamonds', 9, :nine)
    @card3 = Card.new('Diamonds', 11, :ace)
    @card4 = Card.new('Diamonds', 6, :nine)
    @card5 = Card.new('Diamonds', 2, :two)
    @card6 = Card.new('Diamonds', 5, :five)
    @game = Game.new(@dealer, @players, @shoe)
  end

  def test_resolve_stand_walk_to
    @players[0].hit(@card2)
    @game.resolve
    assert_equal(:playing, @players[0].standing, 'P1 should have playing')
    assert_equal(:in, @players[0].status, 'P1 should be in')
    assert_equal(9, @players[0].blackjack_twoone_bust_score, 'P1 should have a score')

    @players[0].hit(@card4)
    @game.resolve
    assert_equal(:playing, @players[0].standing, 'P1 should have playing')
    assert_equal(:in, @players[0].status, 'P1 should be in')
    assert_equal(15, @players[0].blackjack_twoone_bust_score, 'P1 should have a score')

    @players[0].hit(@card6)
    @game.resolve
    assert_equal(:playing, @players[0].standing, 'P1 should have playing')
    assert_equal(:in, @players[0].status, 'P1 should be in')
    assert_equal(:stand, @players[0].blackjack_twoone_bust_score, 'P1 should be standing')
  end

  def test_resolve_stand_p1_over_d_over_p2
    @dealer.hit(@card1)
    @dealer.hit(@card2)
    @players[0].hit(@card1)
    @players[0].hit(@card1)
    @players[1].hit(@card1)
    @players[1].hit(@card4)
    @game.resolve
    assert_equal(:stand, @dealer.blackjack_twoone_bust_score, 'Dealer should be standing')
    assert_equal(:stand, @players[0].blackjack_twoone_bust_score, 'P1 should be standing')
    assert_equal(:stand, @players[1].blackjack_twoone_bust_score, 'P2 should be standing')
    assert_equal(:win, @players[0].standing, 'P1 should have win with 20')
    assert_equal(:out, @players[0].status, 'P1 should be out')
    assert_equal(:out, @players[1].status, 'P2 should be out')
    assert_equal(:loss, @players[1].standing, 'P2 should have lost to dealer')
    assert_equal(%w[w l], @game.result[:result], 'fidy-fidy')
  end

  def test_resolve_bust
    @players[0].hit(@card1)
    @players[0].hit(@card4)
    @players[0].hit(@card1)
    @game.resolve
    assert_equal(:bust, @players[0].blackjack_twoone_bust_score, 'P1 is busted')
    assert_equal(:loss, @players[0].standing, 'P1 should have loss on bust')
    assert_equal(:out, @players[0].status, 'P1 should be out')
    assert_equal(%w[l p], @game.result[:result], 'busted')
  end

  def test_resolve_twoone_on_p1_not_p2_stand_on_d
    @dealer.hit(@card1)
    @dealer.hit(@card4)
    @players[0].hit(@card1)
    @players[0].hit(@card4)
    @players[0].hit(@card6)
    @players[1].hit(@card1)
    @players[1].hit(@card2)
    @game.resolve
    assert_equal(:stand, @dealer.blackjack_twoone_bust_score, 'Dealer should standing')
    assert_equal(:twoone, @players[0].blackjack_twoone_bust_score, 'P1 should have 21')
    assert_equal(:stand, @players[1].blackjack_twoone_bust_score, 'P2 should be standing')
    assert_equal(:win, @players[0].standing, 'P1 should have win with 21')
    assert_equal(:out, @players[0].status, 'P1 should be out')
    assert_equal(:out, @players[1].status, 'P2 should be out')
    assert_equal(:win, @players[1].standing, 'P2 should have beaten dealer')
    assert_equal(%w[w w], @game.result[:result], 'everybody wins')
  end

  def test_resolve_twoone_on_d_p1_not_p2
    @dealer.hit(@card1)
    @dealer.hit(@card4)
    @dealer.hit(@card6)
    @players[0].hit(@card1)
    @players[0].hit(@card4)
    @players[0].hit(@card6)
    @players[1].hit(@card1)
    @players[1].hit(@card2)
    @game.resolve
    assert_equal(:twoone, @dealer.blackjack_twoone_bust_score, 'Dealer should have 21')
    assert_equal(:twoone, @players[0].blackjack_twoone_bust_score, 'P1 should have 21')
    assert_equal(:stand, @players[1].blackjack_twoone_bust_score, 'P2 should be standing')
    assert_equal(:push, @players[0].standing, 'P1 should have push in 21')
    assert_equal(:out, @players[0].status, 'P1 should be out')
    assert_equal(:out, @players[1].status, 'P2 should be out')
    assert_equal(:loss, @players[1].standing, 'P2 should have loss when dealer has 21')
    assert_equal(%w[p l], @game.result[:result], 'nodody wins')
  end

  def test_resolve_blackjack_on_d_p1_not_p2
    @dealer.hit(@card1)
    @dealer.hit(@card3)
    @players[0].hit(@card1)
    @players[0].hit(@card3)
    @players[1].hit(@card1)
    @players[1].hit(@card2)
    @game.resolve
    assert_equal(:blackjack, @dealer.blackjack_twoone_bust_score, 'Dealer should have blackjack')
    assert_equal(:blackjack, @players[0].blackjack_twoone_bust_score, 'P1 should have blackjack')
    assert_equal(:stand, @players[1].blackjack_twoone_bust_score, 'P2 should be standing')
    assert_equal(:push, @players[0].standing, 'P1 should have win')
    assert_equal(:out, @players[0].status, 'P1 should be out')
    assert_equal(:out, @players[1].status, 'P2 should be out')
    assert_equal(:loss, @players[1].standing, 'P2 should have loss')
    assert_equal(%w[p l], @game.result[:result], 'nodody wins')
  end

  def test_resolve_blackjack_on_p1_not_d_p2
    @dealer.hit(@card1)
    @dealer.hit(@card4)
    @players[0].hit(@card1)
    @players[0].hit(@card3)
    @players[1].hit(@card1)
    @players[1].hit(@card2)
    @game.resolve
    assert_equal(:stand, @dealer.blackjack_twoone_bust_score, 'Dealer should be standing')
    assert_equal(:blackjack, @players[0].blackjack_twoone_bust_score, 'P1 should have blackjack')
    assert_equal(:stand, @players[1].blackjack_twoone_bust_score, 'P2 should be standing')
    assert_equal(:win, @players[0].standing, 'P1 should have win')
    assert_equal(:out, @players[0].status, 'P1 should be out')
    assert_equal(:out, @players[1].status, 'P2 should be out')
    assert_equal(:win, @players[1].standing, 'P2 should have win')
    assert_equal(%w[w w], @game.result[:result], 'Everybody wins')
  end

  def test_draw
    @game.draw
    assert_operator(@dealer.hand.hand.size, :>=, 2, 'Dealer should have a proper hand')
    @players.each do |player|
      assert_operator(player.hand.hand.size, :>=, 2, 'Player should have a proper hand')
    end
  end
end
