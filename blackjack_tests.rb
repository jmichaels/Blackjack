# To Run:
# ruby -Ilib:test blackjack_tests.rb

require "minitest/autorun"
require './blackjack.rb'
require 'active_support'

class CardTests < Minitest::Test
  def setup
    @card = Card.new(value: Deck::CARD_VALUES.sample, suit: Deck::CARD_SUITS.sample)
  end

  def test_a_new_card_has_a_valid_value
    assert Deck::CARD_VALUES.include?(@card.value)
  end

  def test_a_new_card_has_a_valid_suit
    assert Deck::CARD_SUITS.include?(@card.suit)
  end

  def test_a_jack_queen_or_king_has_10_points
    assert Card.new(value: 'J', suit: Deck::CARD_SUITS.sample).points == 10
    assert Card.new(value: 'Q', suit: Deck::CARD_SUITS.sample).points == 10
    assert Card.new(value: 'K', suit: Deck::CARD_SUITS.sample).points == 10
  end

  def test_a_number_cards_points_match_its_face_value
    assert Card.new(value: '10', suit: Deck::CARD_SUITS.sample).points == 10
    assert Card.new(value: '5', suit: Deck::CARD_SUITS.sample).points == 5
    assert Card.new(value: '2', suit: Deck::CARD_SUITS.sample).points == 2
  end

  def test_trying_to_get_the_points_value_for_an_ace_should_cause_error
    #ace = Card.new(value: 'A', suit: Deck::CARD_SUITS.sample) 
    #assert_raises ace.points 
    skip
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

  def test_deal_should_give_dealer_two_cards
    @game.deal!
    assert @game.dealer_hand.count == 2
  end

  def test_deal_should_result_in_48_cards_remaining
    assert @game.deck.remaining_cards.count == 52
    @game.deal!
    assert @game.deck.remaining_cards.count == 48
  end
end

class HandTests < Minitest::Test
  def setup
    @hand = Hand.new
  end

  def test_it_counts_number_card_points_correctly
    cards = [
      Card.new(value: '10', suit: Deck::CARD_SUITS.sample),
      Card.new(value: '5', suit: Deck::CARD_SUITS.sample),
      Card.new(value: '4', suit: Deck::CARD_SUITS.sample),
      Card.new(value: '9', suit: Deck::CARD_SUITS.sample)
    ]

    @hand.add(cards)

    assert @hand.points == 28
  end

  def test_ace_counts_as_11_points_if_lt_or_eq_21_total
    cards = [
      Card.new(value: '10', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
    ]

    @hand.add(cards)
    assert @hand.points == 21
  end

  def test_ace_counts_as_1_point_if_11_would_put_total_over_21
    cards = [
      Card.new(value: '10', suit: Deck::CARD_SUITS.sample),
      Card.new(value: '10', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
    ]

    @hand.add(cards)
    assert @hand.points == 21
  end

  def test_aces_are_11_or_1_correctly_when_multiple_aces_are_present
    cards = [
      Card.new(value: '10', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
    ]
    hand = Hand.new
    hand.add(cards)
    assert hand.points == 13

    cards = [
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
    ]
    hand = Hand.new
    hand.add(cards)
    assert hand.points == 14

    cards = [
      Card.new(value: '5', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
      Card.new(value: 'A', suit: Deck::CARD_SUITS.sample),
    ]
    hand = Hand.new
    hand.add(cards)
    assert hand.points == 18
  end
end
