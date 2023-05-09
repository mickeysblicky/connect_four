require_relative 'lib/connect_four_game.rb'
def startup_sequence
    puts "\nWelcome to connect four!"
    output_rules()

    p1name = get_name('Player 1')
    p2name = get_name('Player 2')

    p1token = get_token(p1name)
    if p1token.downcase == 'x'
        p2token = 'O'
        puts "\n#{p2name}. Your token is 'O'.\n"
    elsif p1token.downcase == 'o'
        p2token = 'X'
        puts "\n#{p2name}. Your token is 'X'.\n"
    end

    game = Connect_four.new(p1name, p2name, p1token, p2token)
    game.start_game

end

def output_rules
    puts "\nThe objective of the game is to be the first to form a horizontal,"
    puts "vertical, or diagonal line of four of one's own tokens."
    puts "The tokens being either 'X' or 'O'."
end

def get_name(player)
    puts "\n#{player}. What is your name?"
    name = gets.chomp
end

def get_token(player)
    puts "\n#{player}. What token do you choose? 'X' or 'O'"
    tok = gets.chomp.upcase
    until tok.downcase == 'x' || tok.downcase == 'o'
        puts "\nError. Choose either 'X' or 'O' for your token"
        tok = gets.chomp.upcase
    end
    tok
end
startup_sequence()