class Game
  attr_reader :deck,
              :player_hand,
              :dealer_hand,
              :ui,
              :hl

  def initialize
    @deck = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @ui = UI.new
    @hl = HighLine.new
  end

  def run
    intro
    deal
    #answer = cli.ask('What do you think?')
    #puts "You have answered #{answer}."
  end

  def intro
    ui.clear
    ui.title([
      "Welcome to BlackJack!",
      "A game of chance and skill."
    ])
    ui.space(2)
    hl.ask("Press ENTER to begin...")
    ui.space(2)
    ui.clear
  end

  def deal
    2.times do
      @player_hand.cards << deck.draw_a_card
      @dealer_hand.cards << deck.draw_a_card
    end

    puts

    ui.print_hands(@dealer_hand, @player_hand)

    puts "\nDo you hit or stay?"
    puts "h - Hit"
    puts "s - Stay \n"
  end



=begin
puts "Dealing a new game..."
UI.loading_animation
deal!
puts
@player_hand.cards.each do |card|
  UI.print_card(card)
  sleep 0.5
end
puts '-' * 50
puts "You have: #{@player_hand.points} points.\n"
puts '-' * 50

puts "\nDo you hit or stay?"
puts "h - Hit"
puts "s - Stay \n"
print ":> "
response = STDIN.gets.chomp
puts response
    UI.space(3)
    5.times{ |i| print "\r#{5 - i} Let's begin"; sleep 1 }
    UI.space(1)
=end
#cli = HighLine.new

end
