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
        cards << Card.new(
          value: value,
          suit:  suit
        )
      end
    end
    cards
  end

  def draw_a_card
    remaining_cards.pop
  end
end
