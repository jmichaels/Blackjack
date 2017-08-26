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
    if alignment == 'heading'
      msg = msg.center(TERMINAL_WIDTH - 4)
      msg = "| #{msg}|"
    elsif alignment == 'center'
      msg = msg.center(TERMINAL_WIDTH)
    elsif alignment == 'right'
      msg = msg.rjust(TERMINAL_WIDTH)
    else
      msg = msg.ljust(TERMINAL_WIDTH)
    end

    puts msg
  end

  def space(number=1)
    number.times{ puts }
  end

  def loading_animation
    loading_msg = 'LOADING GAME: '
    (TERMINAL_WIDTH - loading_msg.length).times do |i|
      print "\r" + loading_msg + random_string_of_suit_emojis(i + 1)
      sleep 0.01
    end
  end

  def hr(character='-')
    if character == 'random_suits'
      puts random_string_of_suit_emojis(TERMINAL_WIDTH)
    else
      puts character * TERMINAL_WIDTH
    end
  end

  def print_hand(cards, dealer_card_face_down: false)
    # This is a bit complicated, it's printing out the cards horizontally,
    # which requires generating one row at a time.  So, you have to print the
    # top 1/5 section of each card all on one line, then the 2nd 1/5 on the next.
    rows = []
    rows << cards.map{ "/-----\\" }.join(' ')
    rows << cards.map{ "|     |" }.join(' ')
    rows << print_middle_row_sections(cards, dealer_card_face_down: dealer_card_face_down).join(' ')
    rows << cards.map{ "|     |" }.join(' ')
    rows << cards.map{ "\\-----/" }.join(' ')
    print rows.join("\n")
    space
  end

  def print_middle_row_sections(cards, dealer_card_face_down:)
    middle_row_sections = []
    cards.each_with_index do |card, index|
      if dealer_card_face_down && index == 0
        middle_row_sections << "|  ?  |"
      else
        middle_row_sections << print_card_value_section(card)
      end
    end
    middle_row_sections
  end

  def print_card_value_section(card)
    "|#{card.value.length == 2 ? '' : ' ' } #{card.value}#{suit_emoji_code(card.suit)} |"
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

  def random_string_of_suit_emojis(how_many)
    string = ''
    how_many.times do |i|
      string += suit_emoji_code(Deck::CARD_SUITS.sample)
    end
    string
  end

  def render(view, game)
    clear
    render_heading(game)
    self.send("render_#{view}_view", game)
  end

  def render_heading(game)
    hr('random_suits')
    say "BlackJack", 'heading'
    say "Wins: #{game.win_count} | Losses: #{game.loss_count} | Win %: #{game.win_percentage}", 'heading'
    hr('random_suits')
    space
  end

  def render_intro_view(game)
    suit_emojis = Deck::CARD_SUITS.map{ |name| suit_emoji_code(name) }
                                  .join('')

    hr('#')
    space
    say 'Welcome to BlackJack!', 'heading'
    say suit_emojis, 'heading'
    say 'A game of chance and skill', 'heading'
    space
    hr('#')
    space
  end

  def render_player_move_view(game)
    render_hands(game, dealer_card_face_down: true)
  end

  def render_dealer_move_view(game)
    render_hands(game, dealer_card_face_down: false)
  end

  def render_hands(game, dealer_card_face_down: true)
    hr
    say "YOUR HAND:", 'heading'
    hr
    space
    print_hand(game.player_hand.cards)
    space
    say "You have: #{game.player_hand.points} points."
    space
    hr
    say "DEALER'S HAND:", 'heading'
    hr
    space
    print_hand(game.dealer_hand.cards, dealer_card_face_down: dealer_card_face_down)
    space
    unless dealer_card_face_down
      say "The dealer has: #{game.dealer_hand.points} points."
      space
    end
    hr
  end

  def render_game_end_view(game)
    render_hands(game, dealer_card_face_down: false)
    space(2)
    hr '#'
    space(1)
    case game.result
    when 'tie_win'
      say "It's a tie.  Everybody wins!", 'center'
      say "(Nobody wins.)", 'center'
    when 'tie_lose'
      say "Tie - everyone busted.", 'center'
      say "(Nobody wins.)", 'center'
    when 'player_bust'
      say 'You busted.'
      say 'Womp. Womp.'
    when 'dealer_bust'
      say 'The Dealer busted.'
      say 'Hooray!'
      say 'You win.'
    when 'player_win'
      say 'You win!'
      say "What a lucky #{['gal', 'guy'].sample}!"
    when 'dealer_win'
      say "You lost :'("
      say 'Try again?'
    else
      say "Game ended | #{game.result} | (IMPLEMENT ME)", 'center'
    end
    space(1)
    hr '#'
  end
end
