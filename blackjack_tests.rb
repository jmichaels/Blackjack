# To Run:
# ruby -Ilib:test blackjack_tests.rb

require "minitest/autorun"
require './blackjack.rb'
require 'active_support'

class CardTests < Minitest::Test
  def setup
    @card = Card.new(Deck::VALUES.sample, Deck::SUITS.sample)
  end

  def test_a_new_card_has_a_valid_value
    assert Deck::CARD_VALUES.include?(@card.value)
  end

  def test_a_new_card_has_a_valid_suit
    assert Deck::CARD_SUITS.include?(@card.suit)
  end

  def test_trying_to_get_the_points_value_for_an_ace_should_cause_error
    ace = Card.new.(value: 'A', suit: 'HEARTS') 
    error = assert_raises RuntimeError { ace.points }
    assert_match /ace/, error.message
  end
end

class DeckTests < Minitest::Test
  def setup
    @deck = Deck.new
  end

  def test_deck_has_52_cards
    assert @deck.remaining_cards.length == 52
  end

  def test_each_card_is_unique
    assert @deck.remaining_cards.uniq.length == 52
  end

  def test_drawing_a_card_removes_it_from_deck
    deck = Deck.new
    drawn_card = deck.draw_a_card
    refute deck.remaining_cards.include?(drawn_card)
  end

  def test_drawing_a_card_reduces_deck_card_count_by_one
    deck = Deck.new
    initial_count = deck.remaining_cards.count
    deck.draw_a_card
    assert deck.remaining_cards.count == initial_count - 1
  end
end


class GameTests < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_new_game_has_a_deck_with_52_cards
    @game.deck.remaining_cards == 52
  end

  def test_deal_should_give_player_two_cards
    @game.deal!
    assert @game.player_hand.count == 2
  end

  def test_deal_should_result_in_50_cards_remaining
    assert @game.deck.remaining_cards.count == 52
    @game.deal!
    assert @game.deck.remaining_cards.count == 50
  end
end
