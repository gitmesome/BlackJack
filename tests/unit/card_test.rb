# frozen_string_literal: true

require 'minitest/autorun'
require 'card'

# Test the Card class
class TestCard < Minitest::Test
  def setup
    @card1 = Card.new('Hearts', 11, :ace)
    @card2 = Card.new('Hearts', 10, :queen)
  end

  def test_ace
    assert_equal(@card1.ace?, true, 'card1 should be an Ace')
    assert_equal(@card2.ace?, false, 'card2 should NOT be an Ace')
  end
end
