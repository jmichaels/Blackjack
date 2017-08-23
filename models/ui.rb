class UI
  TERMINAL_WIDTH = 80
  attr_reader :hl

  def initialize
    @hl = HighLine.new
  end

  def clear
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
  end

  def say(msg, alignment='left')
    if alignment == 'center'
      puts msg.center(TERMINAL_WIDTH)
    elsif alignment == 'right'
      puts msg.rjust(TERMINAL_WIDTH)
    else
      puts msg.ljust(TERMINAL_WIDTH)
    end
  end

  def title(msg)
    # Can accept a string or an array, if multi-line title

    lines = [msg].flatten

    puts '#' * TERMINAL_WIDTH
    puts
    lines.each{ |line| say(line, 'center') }
    puts
    puts '#' * TERMINAL_WIDTH
  end

  def space(number=1)
    number.times{ puts }
  end

  def loading_animation
    puts
    50.times do
      print '-'
      sleep 0.02
    end
    puts
  end

  def print_hands(dealer_hand, player_hand)
    say "YOUR HAND:", 'center'
    space(2)

    print_hand(player_hand.cards)

    hr
    puts "You have: #{player_hand.points} points.\n"
    hr
  end

  def hr(character='-')
    puts character * TERMINAL_WIDTH
  end

  def print_hand(cards)
    cards.each{ print "/-----\\ " }
    space(1)
    cards.each{ print "|     | " }
    space(1)
    cards.each{ |card| print print_card_value_section(card) + " " }
    space(1)
    cards.each{ print "|     | " }
    space(1)
    cards.each{ print "\\-----/ " }
    space(2)
  end

  def print_card_value_section(card)
    "|  #{card.value}#{suit_emoji_code(card.suit)}#{card.value.length == 2 ? '' : ' ' }|"
  end

  def ask(msg)
    @hl.ask(msg)
  end

  def suit_emoji_code(name)
    case name.upcase
    when "HEARTS"
      "\u{2665}"
    when "DIAMONDS"
      "\u{2666}"
    when "CLUBS"
      "\u{2663}"
    when "SPADES"
      "\u{2660}"
    else
      raise "Invalid suit name."
    end
  end
end
