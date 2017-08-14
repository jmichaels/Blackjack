class Card
  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def points
    case value
    when 'J' || 'Q' || 'K'
      10 
    when 'A'
      raise 'The value of an ace must be calculated based on the rest of the hand.'
    else
      value.to_i
    end
  end
end

class Deck
  CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  CARD_SUITS = %w(HEARTS CLUBS SPADES DIAMONDS)

  attr_reader :remaining_cards

  def initialize
    @remaining_cards = Deck.all_cards
                           .shuffle
  end

  def self.all_cards
    cards = []
    CARD_SUITS.each do |suit|
      CARD_VALUES.each do |value|
        cards << OpenStruct(
          value:  value,
          suit:   suit,
          points: Game.get_
        )
      end
    end
    cards
  end

  def draw_a_card
    remaining_cards.pop
  end
end

class Game
  attr_reader :deck,
              :player_hand,
              :dealer_hand

  def initialize
    @deck = Deck.new
    @player_hand = []
    @dealer_hand = []
  end

  def deal!
    2.times do
      @player_hand << deck.draw_a_card
    end
  end

  def hit!
  end

  def count_hand_points(hand)
    aces = []
    total_points = 0

    hand.each do |card|
      value = card.value

      if value == 'A'
        aces << card
      else
        total_points += card.points
      end
    end
 
    acs.each do |ace|
      if total_points < 
    end
  end

  def get_card_points(card_value)
  end
end
