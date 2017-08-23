class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add(one_or_more_cards)
    cards = [one_or_more_cards].flatten
    @cards += cards
  end

  def points
    number_of_aces = cards.select{ |card| card.value == 'A' }.count
    non_ace_cards  = cards.reject{ |card| card.value == 'A' }

    total_points = 0

    non_ace_cards.each{ |card| total_points += card.points }

    number_of_aces.times do |i|
      aces_left_to_count = number_of_aces - (i + 1)
      if total_points + 11 + aces_left_to_count <= 21
        total_points += 11
      else
        total_points += 1
      end
    end

    total_points
  end
end
