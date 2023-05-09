require_relative '../lib/connect_four_game.rb'

describe Connect_four do 

    describe '#start_game' do
        
        context 'when new game is started' do 
            subject(:new_game) {described_class.new('mickey', 'pendejo')}
            before do
                allow(new_game).to receive(:show_board)
                allow(new_game).to receive(:over?).and_return(true)
                allow(new_game).to receive(:round)
           end

            xit 'creates a board' do 
                expect{new_game.start_game}.to change{new_game.instance_variable_get(:@rows)}.from([]).to([
                    row6 = "|___|___|___|___|___|___|___|",
                    row5 = "|___|___|___|___|___|___|___|",
                    row4 = "|___|___|___|___|___|___|___|",
                    row3 = "|___|___|___|___|___|___|___|",
                    row2 = "|___|___|___|___|___|___|___|",
                    row1 = "|___|___|___|___|___|___|___|"
                ])
            end
        end

        context 'when over?() calls round twice'do
            subject(:new_game) {described_class.new('michael', 'pendeja')}
            
            before do 
                allow(new_game).to receive(:make_board)
                allow(new_game).to receive(:show_board)
                allow(new_game).to receive(:over?).and_return(false, false, true)
            end

            it 'calls round() twice' do
                expect(new_game).to receive(:round).twice
                new_game.start_game
            end
        end

        context 'when over?() calls round() three times' do
            subject(:new_game) {described_class.new('mickey', 'caca')}

            before do 
                allow(new_game).to receive(:make_board)
                allow(new_game).to receive(:show_board)
                allow(new_game).to receive(:over?).and_return(false, false, false, true)
            end

            it 'calls round() three times' do
                expect(new_game).to receive(:round).thrice
                new_game.start_game
            end
        end

        context 'when over?() calls round() 4 times' do 
            subject(:new_game) {described_class.new('mf', 'fm')}

            before do
                allow(new_game).to receive(:make_board)
                allow(new_game).to receive(:show_board)
                allow(new_game).to receive(:over?).and_return(false, false, false, false, true)
            end

            it 'calls round() 4 times' do 
                expect(new_game).to receive(:round).exactly(4).times
                new_game.start_game
            end
        end
    end

    describe '#round' do

        context 'when a round starts' do 
            subject(:new_game) {described_class.new('mi', 'li')}

            before do 
                allow(new_game).to receive(:make_move)
            end
            
            it 'updates round number to 1' do 
                expect {new_game.round}.to change {new_game.instance_variable_get(:@round_num)}.from(0).to(1)
            end
        end

        context 'when make_move() is called' do
            subject(:new_game) {described_class.new('f', 'c')}

            it 'instance receives make_move()' do 
                expect(new_game).to receive(:make_move).with('f')
                expect(new_game).to receive(:make_move).with('c')
                new_game.round
            end
        end
    end

    describe '#make_move' do 

        context 'when move is not valid' do
            subject(:new_game) {described_class.new('s', 'd')}
            
            before do 
                allow(new_game).to receive(:puts)
                unvalid_input = '8'
                valid_input = '7'
                allow(new_game).to receive(:gets).and_return(unvalid_input, valid_input)
                allow(new_game).to receive(:move_to_board)
                allow(new_game).to receive(:win?)
            end

            it 'outputs error message once' do 
                error_message = "Error. Move must be 1, 2, 3, 4, 5, 6, or 7."
                expect(new_game).to receive(:puts).with(error_message).once
                new_game.make_move('s')
            end
        end

        context 'when move is valid' do 
            subject(:new_game) {described_class.new('dfd', 'fda')}

            before do 
                allow(new_game).to receive(:puts)
                allow(new_game).to receive(:gets).and_return('2')
            end

            it 'calls move_to_board()' do 
                expect(new_game).to receive(:move_to_board)
                new_game.make_move('dfd')
            end
        end

        context 'after move_to_board() is called' do 
            subject(:new_game) {described_class.new('f', 'a')}

            before do 
                allow(new_game).to receive(:puts)
                allow(new_game).to receive(:gets).and_return('1')
                allow(new_game).to receive(:move_to_board)
            end

            it 'calls win?()' do 
                expect(new_game).to receive(:win?)
                new_game.make_move('f')
            end
        end
    end

    describe '#move_to_board' do 

        context 'when move is 1 and no other number is on top' do 
            subject(:new_game) { described_class.new('d', 'a') }


            it 'adds letter to row1 1st place' do 
                rows = new_game.instance_variable_get(:@rows)
                expect{new_game.move_to_board('1', 'd')}.to change{rows[5][2]}.from('_').to('X')
                puts rows
            end
        end

        context 'when move is 1 and there is a number on top' do 
            subject(:new_game) {described_class.new('c', 'b')}

            before do 
                allow(new_game).to receive(:make_move).with('c')
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
            end

            it 'adds letter to row2 1st place' do 
                rows = new_game.instance_variable_get(:@rows)
                expect{new_game.move_to_board('1', 'c')}.to change{rows[4][2]}.from('_').to('X')
                puts rows
            end
        end

        context 'when row is below 0' do
            subject(:new_game) {described_class.new('a', 'c')}

            before do 
                allow(new_game).to receive(:make_move).with('a')
            end 

            it 'outputs error message' do
                error_message = "Error. Column is filled choose another place."
                expect(new_game).to receive(:puts).with(error_message)
                new_game.move_to_board('1', 'a', -1)
            end

        end

        context 'when move is 2 and no other number is on top' do 
            subject(:new_game) {described_class.new('a', 'sa')}

            it 'adds letter to row1 2nd place' do
                rows = new_game.instance_variable_get(:@rows)
                expect{new_game.move_to_board('2', 'a')}.to change{rows[5][6]}.from('_').to('X')
                puts rows
            end
        end

        context 'when move is 2 and there is a number on top' do 
            subject(:new_game) {described_class.new('a', 'v')}

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][6] = 'X'
                allow(new_game).to receive(:make_move).with('a')
            end

            it 'adds letter to row2 2nd place' do 
                rows = new_game.instance_variable_get(:@rows)
                expect{new_game.move_to_board('2', 'a')}.to change{rows[4][6]}.from('_').to('X')
                puts rows
            end
        end
    end

    describe '#win?' do 

        context 'when there is a vertical line of the same letter' do
            subject(:new_game) {described_class.new('mickey', 'nalgas', 'X', 'O')}

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[4][2] = 'X'
                rows[3][2] = 'X'
                rows[2][2] = 'X'
                allow(new_game).to receive(:valid_difference?).and_return(true)
                allow(new_game).to receive(:vertical_line_column?).and_return(true)
            end

            it 'outputs winning message' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                message = "vertical line detected: [2, 3, 4, 5]"
                message2 = "mickey. You won!"
                expect(new_game).to receive(:puts).with(message)
                expect(new_game).to receive(:puts).with(message2)
                new_game.win?('mickey')
            end
        end

        context 'when there is a horizontal line of the same letter' do 
            subject(:new_game) {described_class.new('mickey', 'nalgitas', 'X', 'O')}

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[5][6] = 'X'
                rows[5][10] = 'X'
                rows[5][14] = 'X'
                allow(new_game).to receive(:vertical_line_column?).and_return(false)
                allow(new_game).to receive(:valid_difference?).and_return(false)
                allow(new_game).to receive(:vertical_line_column?).and_return(false)
                allow(new_game).to receive(:valid_difference?).and_return(true)
                allow(new_game).to receive(:horizontal_line_row?).and_return(true)
            end

            it 'outputs winning message' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                message = "horizontal line detected: [0, 1, 2, 3]"
                message2 = "mickey. You won!"
                expect(new_game).to receive(:puts).with(message)
                expect(new_game).to receive(:puts).with(message2)
                new_game.win?('mickey')
            end
        end

        context 'when there is a diagonal line of the same letter' do 
            subject(:new_game) {described_class.new('mickey', 'nalgas', 'X', 'O')}

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[4][6] = 'X'
                rows[3][10] = 'X'
                rows[2][14] = 'X'
                allow(new_game).to receive(:vertical_line_column?).and_return(false)
                allow(new_game).to receive(:valid_difference?).and_return(false)
                allow(new_game).to receive(:vertical_line_column?).and_return(false)
                allow(new_game).to receive(:valid_difference?).and_return(false)
                allow(new_game).to receive(:horizontal_line_row?).and_return(false)
                allow(new_game).to receive(:diagonal_line?).and_return(true)
            end

            it 'outputs winning message' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                message = "diagonal line detected: row: [2, 3, 4, 5] column: [3, 2, 1, 0]"
                message2 = 'mickey. You won!'
                expect(new_game).to receive(:puts).with(message)
                expect(new_game).to receive(:puts).with(message2)
                new_game.win?('mickey')
            end
        end
    end

    describe '#valid_difference?' do

        context "when given array of row nums that contain a token and have 4 numbers that all have a difference of 1" do 
            subject(:new_game) {described_class.new('mickey', 'cheeks', 'X', 'O')}

            it 'returns true' do 
                array = [2, 3, 4, 5]
                expect(new_game.valid_difference?(array)).to eq(true)
            end
        end

        context "when given array of row nums that contain a token and have 4 numbers that have difference of 1" do 
            subject(:new_game) {described_class.new('mickey', 'chango', 'X', 'O')}

            it 'changes @valid_line' do 
                array = [2, 3, 4, 5]
                expect {new_game.valid_difference?(array)}.to change{new_game.instance_variable_get(:@valid_line)}.from([]).to([5, 4, 3, 2])
            end
        end

        context "when given array of row nums that contain a token and does not have 4 numbers" do 
            subject(:new_game) {described_class.new('mickey', 'mouse', 'X', 'O')}

            it 'returns false' do 
                array = [3, 4, 5]
                expect(new_game.valid_difference?(array)).to eq(false)
            end
        end

        context "when given array of column nums that contain a token and have 4 numbers that all have a difference of 1" do 
            subject(:new_game) {described_class.new('mickey', 'chango', 'X', 'O')}

            it 'returns true' do 
                array = [0, 1, 2, 3]
                expect(new_game.valid_difference?(array)).to eq(true)
            end
        end

        context 'when given an array with lots of column nums that contain a token and have 4 numbers that all have a difference of 1' do 
            subject(:new_game) {described_class.new('mickey', 'channgo', 'X', 'O')}

            it 'returns true' do 
                array = [0, 2, 3, 5, 6, 0, 1, 2, 3, 5, 0, 3, 4]
                expect(new_game.valid_difference?(array)).to eq(true)
            end
        end

        context "when given array of columns nums that contain a token and does not have 4 numbers" do 
            subject(:new_game) {described_class.new('mickey', 'Chango17', 'X', 'O')}

            it 'returns false' do 
                array = [1, 3, 4]
                expect(new_game.valid_difference?(array)).to eq(false)
            end
        end
    end

    describe '#vertical_line_column?' do 
        subject(:new_game) {described_class.new('mickey', 'Chango', 'X', 'O')}

        context 'when given an array of valid row numbers and there is a vertical line' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[4][2] = 'X'
                rows[3][2] = 'X'
                rows[2][2] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                valid_line = [5, 4, 3, 2]
                expect(new_game.vertical_line_column?(valid_line, 'X')).to eq(true)
            end
        end

        context 'when given an array of valid row numbers and there is a vertical line' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[3][6] = 'X'
                rows[2][6] = 'X'
                rows[1][6] = 'X'
                rows[0][6] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                valid_line = [3, 2, 1, 0]
                expect(new_game.vertical_line_column?(valid_line, 'X')).to eq(true)
            end
        end

        context 'when given an array of valid row numbers and there is a vertical line' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[4][26] = 'X'
                rows[3][26] = 'X'
                rows[2][26] = 'X'
                rows[1][26] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                valid_line = [4, 3, 2, 1]
                expect(new_game.vertical_line_column?(valid_line, 'X')).to eq(true)
            end
        end

        context 'when given an array of unvalid row numbers ' do 
            
            it 'returns false' do 
                unvalid_array = []
                expect(new_game.vertical_line_column?(unvalid_array, 'X')).to eq(false)
            end
        end
    end

    describe '#horizontal_line_row?' do 
        subject(:new_game) {described_class.new('mickey', 'cheeks', 'X', 'O')}
        
        context 'when given an array of valid column numbers and there is a horizontal line' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[5][6] = 'X'
                rows[5][10] = 'X'
                rows[5][14] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                valid_line = [3, 2, 1, 0]
                expect(new_game.horizontal_line_row?(valid_line, 'X')).to eq(true)
            end
        end

        context 'when given an array of vavlid column numbers and there is a horizontal line' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[5][6] = 'X'
                rows[5][10] = 'X'
                rows[4][14] = 'X'
                rows[4][18] = 'X'
                rows[4][22] = 'X'
                rows[4][26] = 'X'
            end
 
            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                valid_line = [6, 5, 4, 3]
                expect(new_game.horizontal_line_row?(valid_line, 'X')).to eq(true)
            end
        end

        context 'when given an array of unvalid nums' do 

            it 'returns false' do 
                unvalid_array = []
                expect(new_game.horizontal_line_row?(unvalid_array, 'X')).to eq(false)
            end
        end 
    end

    describe '#diagonal_line?' do 
        subject(:new_game) {described_class.new('mickey', 'chango', 'X', 'O')}

        context 'when there is a diagonal line' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[4][6] = 'X'
                rows[3][10] = 'X'
                rows[2][14] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end

        end

        context 'when there is no diagonal line' do 
             
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[4][2] = 'X'
                rows[3][2] = 'X'
                rows[2][2] = 'X'
            end

            it 'returns false' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(false)
            end
        end

        context 'when there is no diagonal line and there are other tokens' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[4][6] = 'X'
                rows[3][10] = 'O'
                rows[2][14] = 'X'
                rows[1][18] = 'O'
                rows[0][22] = 'X'
            end

            it 'returns false' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(false)
            end
        end

        context 'when there is a diagonal line with other tokens' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'O'
                rows[4][6] = 'X'
                rows[3][10] = 'X'
                rows[2][14] = 'X'
                rows[1][18] = 'X'
                rows[0][22] = 'O'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonall line with other tokens' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][26] = 'O'
                rows[4][22] = 'X'
                rows[3][18] = 'X'
                rows[2][14] = 'X'
                rows[1][10] = 'X'
                rows[0][6] = 'O'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonal line on column 3 going to the right' do 
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[0][14] = 'X'
                rows[1][18] = 'X'
                rows[2][22] = 'X'
                rows[3][26] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonal line on column 3 going to the left' do 
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[0][14] = 'X'
                rows[1][10] = 'X'
                rows[2][6] = 'X'
                rows[3][2] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonal line on row 1 going to the right' do 
             
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[1][2] = 'X'
                rows[2][6] = 'X'
                rows[3][10] = 'X'
                rows[4][14] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows) 
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonal line on row 1 going to the left' do 
             
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[1][26] = 'X'
                rows[2][22] = 'X'
                rows[3][18] = 'X'
                rows[4][14] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows) 
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonal line on row 2 going to the right' do 
             
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[2][2] = 'X'
                rows[3][6] = 'X'
                rows[4][10] = 'X'
                rows[5][14] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows) 
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end

        context 'when there is a diagonal line on row 2 going to the left' do 
             
            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[2][26] = 'X'
                rows[3][22] = 'X'
                rows[4][18] = 'X'
                rows[5][14] = 'X'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows) 
                puts rows
                expect(new_game.diagonal_line?('X')).to eq(true)
            end
        end
    end

    describe '#tie?' do 
        subject(:new_game) {described_class.new('mickey', 'chango', 'X', 'O')}
        context 'when board is filled' do 

            before do 
                rows = new_game.instance_variable_get(:@rows)
                rows[5][2] = 'X'
                rows[5][6] = 'X'
                rows[5][10] = 'X'
                rows[5][14] = 'X'
                rows[5][18] = 'X'
                rows[5][22] = 'X'
                rows[5][26] = 'X'
                rows[4][2] = 'O'
                rows[4][6] = 'O'
                rows[4][10] = 'O'
                rows[4][14] = 'O'
                rows[4][18] = 'O'
                rows[4][22] = 'O'
                rows[4][26] = 'O'
                rows[3][2] = 'X'
                rows[3][6] = 'X'
                rows[3][10] = 'X'
                rows[3][14] = 'X'
                rows[3][18] = 'X'
                rows[3][22] = 'X'
                rows[3][26] = 'X'
                rows[2][2] = 'O'
                rows[2][6] = 'O'
                rows[2][10] = 'O'
                rows[2][14] = 'O'
                rows[2][18] = 'O'
                rows[2][22] = 'O'
                rows[2][26] = 'O'
                rows[1][2] = 'X'
                rows[1][6] = 'X'
                rows[1][10] = 'X'
                rows[1][14] = 'X'
                rows[1][18] = 'X'
                rows[1][22] = 'X'
                rows[1][26] = 'X'
                rows[0][2] = 'O'
                rows[0][6] = 'O'
                rows[0][10] = 'O'
                rows[0][14] = 'O'
                rows[0][18] = 'O'
                rows[0][22] = 'O'
                rows[0][26] = 'O'
            end

            it 'returns true' do 
                rows = new_game.instance_variable_get(:@rows)
                puts rows
                expect(new_game.tie?).to eq(true)
            end
        end
    end

end