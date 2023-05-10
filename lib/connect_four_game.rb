class Connect_four

    def initialize(player1 = 'player1', player2 = 'player2', p1token = 'X', p2token = 'O', rows = [row0 = "|___|___|___|___|___|___|___|",row1 = "|___|___|___|___|___|___|___|",row2 = "|___|___|___|___|___|___|___|",row3 = "|___|___|___|___|___|___|___|",row4 = "|___|___|___|___|___|___|___|",row5 = "|___|___|___|___|___|___|___|"])
        @player1 = player1
        @player2 = player2
        @p1token = p1token
        @p2token = p2token
        @rows = rows
        @column = [
            column0 = 2,
            column1 = 6,
            column2 = 10,
            column3 = 14,
            column4 = 18,
            column5 = 22,
            column6 = 26
          ]
        @round_num = 0
        @good_nums = ['1', '2', '3', '4', '5', '6', '7']
    end

    def start_game
        show_board()
        until over?()
            round()
        end
        replay()
    end

    def round
        @round_num += 1
        puts "\nRound #{@round_num}"

        make_move(@player1)
        if win?(@player1)
            return
        end
        make_move(@player2)
    end

    def make_move(player)
        puts "\n#{player}. What is your move?"
        move = gets.chomp
        until @good_nums.any?(move)
            puts "\nError. Move must be 1, 2, 3, 4, 5, 6, or 7."
            puts "\nWhat is your move?"
            move = gets.chomp
        end
        move_to_board(move, player)
        show_board()
        win?(player)
    end

    def move_to_board(move, player, row = 5)
        if player == @player1
            token = @p1token
          elsif player == @player2 
            token = @p2token
        end

        move = move.to_i
        column = @column[move-1]
        if row == -1
            puts "\nError. Column is filled choose another place."
            make_move(player)
        elsif @rows[row][@column[move-1]] == '_'

            @rows[row][@column[move-1]] = token

        elsif @rows[row][@column[move-1]] != '_'
            row -= 1
            move_to_board(move, player, row)
        end
    end

    def win?(player)

      if player == @player1
        token = @p1token
      elsif player == @player2 
        token = @p2token
      end

      token_rows = @rows.select{|row| row.include?(token)}
      if token_rows == []
        return false
      end
      token_row_nums = []
      @rows.each_with_index do |row, i|
        if row.include?(token)
            token_row_nums << i
        end
      end
      token_column_nums = []
      token_rows.each_with_index do |row, index|

        @column.each_with_index do |col, i|
            if row[col] == token
                token_column_nums << i
            end
        end
      end

      
      if vertical_line_column?(token)
        return true
      elsif horizontal_line_row?(token)
        return true
      elsif diagonal_line?(token)
        return true
      end
    end

    def tie?
        count = 0
        filled = false
        not_filled = false
        @rows.each do |r|
            break if not_filled == true
            break if filled == true
            @column.each_with_index do |c, i|
                if r[c] != '_'
                    count += 1
                    if count == 42
                        filled = true
                        break
                    end
                elsif r[c] = '_'
                    not_filled = true
                    break
                end
            end
        end

        if filled == true
            return true
        elsif not_filled == true
            return false
        end
    end

    def over?
        if win?(@player1)
            puts "\n#{@player1}. You won!"
            return true
        elsif win?(@player2)
            puts "\n#{@player2}. You won!"
            return true
        elsif tie?()
            puts "\nGame over."
            puts "\n#{@player1} and #{@player2} tied."
            return true
        end
    end 
    
    def vertical_line_column?(token)
        vertical_line = false
        @column.each do |c|
            break if vertical_line == true
            count = 0
            @rows.each_with_index do |r, i|
                if r[c] == token
                    count += 1
                    if count == 4
                        vertical_line = true
                        break
                    end
                elsif r[c] != token
                    count = 0
                end
            end
        end 
        
        return true if vertical_line == true
        return false if vertical_line == false
        
    end
    
    def horizontal_line_row?(token)
        horizontal_line = false
        @rows.each do |r|
            break if horizontal_line == true
            count = 0
            @column.each do |c|     
                if r[c] == token
                    count += 1
                    if count == 4 
                        horizontal_line = true
                        break
                    end
                elsif r[c] != token 
                    count = 0
                end 
            end
        end
        
        return true if horizontal_line == true
        return false if horizontal_line == false
    end 
    
    def diagonal_line?(token)
        diagonal_line = false
        @rows.each_with_index do |r, i|
            break if diagonal_line == true
            break if i == 3

            @column.each_with_index do |column, index|
                break if diagonal_line == true
                count = 0
                if [0, 1, 2].any?(index)
                    row_iterator = i
                    column_iterator = index
                    
                    while column_iterator != 7 && row_iterator != 6
                        
                        if @rows[row_iterator][@column[column_iterator]] == token
                            count += 1
                            if count == 4
                                diagonal_line = true
                                break
                            end
                        elsif @rows[row_iterator][@column[column_iterator]] != token
                            count = 0
                        end
                        
                        row_iterator += 1
                        column_iterator += 1
                    end
                elsif [4, 5, 6].any?(index) 
                    row_iterator = i
                    column_iterator = index
                    while column_iterator != -1 && row_iterator != 6
                        
                        if @rows[row_iterator][@column[column_iterator]] == token
                            count += 1
                            if count == 4 
                                diagonal_line = true
                                break
                            end
                        elsif @rows[row_iterator][@column[column_iterator]] != token
                            count = 0
                        end
                        
                        row_iterator += 1
                        column_iterator -= 1
                    end
                elsif index == 3
                    row_iterator = i
                    column_iterator = index
                    
                    while column_iterator != 7 && row_iterator != 6
                        
                        if @rows[row_iterator][@column[column_iterator]] == token
                            count += 1
                            if count == 4
                                diagonal_line = true
                                break
                            end
                        elsif @rows[row_iterator][@column[column_iterator]] != token
                            count = 0
                        end
                        
                        row_iterator += 1
                        column_iterator += 1
                    end
                    
                    break if diagonal_line == true
                    
                    row_iterator = i
                    column_iterator = index
                    count = 0
                    
                    while column_iterator != -1 && row_iterator != 6
                        
                        if @rows[row_iterator][@column[column_iterator]] == token
                            count += 1
                            if count == 4 
                                diagonal_line = true
                                break
                            end
                        elsif @rows[row_iterator][@column[column_iterator]] != token
                            count = 0
                        end

                        row_iterator += 1
                        column_iterator -= 1
                    end

                end
            end
        end
        
        return true if diagonal_line == true
        return false if diagonal_line == false
    end
    
    def replay
        puts "\nDo you want to play again?"
        puts "\n'y' for yes. 'n' for no."
        
        response = gets.chomp.downcase
        until response == 'n' || response == 'y'
            puts "Error."
            puts "\nDo you want to play again?"
            puts "\n'y' for yes. 'n' for no."
            response = gets.chomp
        end
        if response == 'y'
            switch_players()
            reset_board()
            start_game()
        elsif response == 'n'
            return
        end
    end

    def reset_board
        @rows = [
            row0 = "|___|___|___|___|___|___|___|",
            row1 = "|___|___|___|___|___|___|___|",
            row2 = "|___|___|___|___|___|___|___|",
            row3 = "|___|___|___|___|___|___|___|",
            row4 = "|___|___|___|___|___|___|___|",
            row5 = "|___|___|___|___|___|___|___|"
          ]
    
          @round_num = 0
    end
    
    def switch_players()
        player1 = @player1
        p1token = @p1token
        player2 = @player2
        p2token = @p2token
        @player1 = player2
        @p1token = p2token
        @player2 = player1
        @p2token = p1token
    end
    
    def show_board
        puts ' '
        puts @rows
        puts "  1   2   3   4   5   6   7  "
    end
end