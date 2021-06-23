# frozen_string_literal: true

require 'minitest/autorun'
require 'shoe'

# Test the Shoe class
class TestShoe < Minitest::Test
  def setup
    @shoe = Shoe.new
  end

  def test_shoe_size
    assert_equal(312, @shoe.size, 'Wrong shoe size')
  end

  def test_deal
    card = @shoe.deal
    assert_equal(311, @shoe.size, 'Wrong shoe size after first deal')
    312.times { card = @shoe.deal }
    assert_nil(card, 'No more cards left in the shoe')
  end
end
