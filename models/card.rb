class Card
  attr_reader :value, :suit

  def initialize(value:, suit:)
    @value = value
    @suit = suit
  end

  def points
    case value
    when 'J'
      10
    when 'Q'
      10
    when 'K'
      10
    when 'A'
      raise 'The value of an ace must be calculated based on the rest of the hand.'
    else
      value.to_i
    end
  end
end
