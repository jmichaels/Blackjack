class Game
  attr_reader :deck,
              :player_hand,
              :dealer_hand,
              :ui,
              :hl,
              :result,
              :win_count,
              :loss_count,
              :tie_count

  def initialize
    @deck = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @ui = UI.new
    @hl = HighLine.new
    @result = nil
    @win_count = 0
    @loss_count = 0
    @tie_count = 0
  end

  def run
    intro
    deal
    check_for_naturals
    player_move
  end

  def replay
    @deck = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @result = nil

    deal
    check_for_naturals
    player_move
  end

  def intro
    ui.render('intro', self)
    hl.ask("Press ENTER to begin...")
    ui.loading_animation
  end

  def deal
    2.times do
      @player_hand.cards << deck.draw_a_card
      @dealer_hand.cards << deck.draw_a_card
    end
  end

  def check_for_naturals
    if @player_hand.points == 21 && @dealer_hand.points == 21
      end_game('tie_win')
    elsif @player_hand.points == 21
      end_game('player_win')
    elsif @dealer_hand.points == 21
      end_game('dealer_win')
    end
  end

  def player_move
    ui.render('player_move', self)

    hl.choose do |menu|
      menu.prompt = "Do you 'hit' or 'stand'?"
      menu.choice(:hit) { player_hit }
      menu.choice(:stand) { player_stand }
    end
  end

  def player_hit
    ui.say "You hit."
    @player_hand.cards << deck.draw_a_card

    sleep 0.5

    if @player_hand.points > 21
      end_game('player_bust')
    elsif @player_hand.points == 21
      ui.say "You have 21 points."
      ui.say "Dealer's move."
      sleep 1
      dealer_move
    else
      player_move
    end
  end

  def player_stand
    ui.say "You stand."
    dealer_move
  end

  def check_for_player_bust
    if @player_hand.points > 21
      end_game('player_bust')
    end
  end

  def dealer_move
    ui.render('dealer_move', self)

    if @dealer_hand.points < 17 || @dealer_hand.points < @player_hand.points
      @dealer_hand.cards << @deck.draw_a_card
      ui.say "The Dealer hits."
      sleep 2
      if @dealer_hand.points > 21
        end_game('dealer_bust')
      else
        dealer_move
      end
    else
      ui.say "The Dealer stands."
      sleep 2
      check_for_game_end
    end

  end

  def check_for_game_end
    if @player_hand.points == 21 && @dealer_hand.points == 21
      end_game('tie_win')
    elsif @player_hand.points > 21 && @dealer_hand.points > 21
      end_game('tie_bust')
    elsif @player_hand.points > 21
      end_game('player_bust')
    elsif @dealer_hand.points > 21
      end_game('dealer_bust')
    elsif @player_hand.points == 21
      end_game('player_win')
    elsif @dealer_hand.points == 21
      end_game('dealer_win')
    elsif @dealer_hand.points >= @player_hand.points
      end_game('dealer_win')
    elsif @dealer_hand.points < @player_hand.points
      end_game('player_win')
    else
      raise "This shouldn't happen"
    end
  end

  def end_game(result)
    @result = result
    update_stats(result)
    ui.render('game_end', self)
    hl.ask("Press ENTER to play again, or CTRL+C to quit")
    replay
  end

  def update_stats(result)
    if ['player_win', 'dealer_bust'].include?(result)
      add_win
    elsif ['dealer_win', 'player_bust'].include?(result)
      add_loss
    else
      add_tie
    end
  end

  def win_percentage
    if win_count == 0 && loss_count == 0
      'N/A'
    elsif win_count > 0 && loss_count == 0
      '100'
    else
      # We're not including ties in this calculation
      total_games = win_count + loss_count
      ((win_count.to_f / total_games.to_f) * 100).round.to_s
    end
  end

  def add_win
    @win_count += 1
  end

  def add_loss
    @loss_count += 1
  end

  def add_tie
    @tie_count += 1
  end
end
