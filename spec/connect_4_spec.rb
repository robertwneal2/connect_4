require_relative '../lib/connect_4'

describe Board do

  # #set_val and #get_val too simple to need to test. #display does not need to be tested since it just puts values

  describe '#reset' do
    subject(:board_clear) { described_class.new }

    it 'resets the board' do
      row = 0
      col = 3
      color = 'B'
      board_clear.send(:set_val, row, col, color)
      board_clear.reset
      new_value = board_clear.send(:get_val, row, col)
      expect(new_value).to be_falsy
    end
  end

  describe '#make_move' do
    subject(:board_make_move) { described_class.new}
    
    context 'when first move of game' do
    
      row = 0
      before do
        allow(board_make_move).to receive(:find_row).and_return(row)
      end

      it 'updates @grid with move' do
        col = 3
        color = 'B'
        board_make_move.make_move(col, color)
        value = board_make_move.send(:get_val, row, col)
        expect(value).to eq(color)
      end

      it 'returns true after move made' do
        col = 3
        color = 'B'
        result = board_make_move.make_move(col, color)
        expect(result).to be_truthy
      end
    end

    context 'when column full' do
    
      row = nil
      before do
        allow(board_make_move).to receive(:find_row).and_return(row)
      end
  
      it 'returns false' do
        col = 3
        color = 'B'
        result = board_make_move.make_move(col, color)
        expect(result).to be_falsy
      end
    end
  end

  describe '#find_row' do
    subject(:board_find_row) { described_class.new}

    it 'finds the first row of an empty column' do
      col = 4
      result = board_find_row.send(:find_row, col)
      expect(result).to eq(0)
    end

    it 'finds the first row of a partially populated column' do
      col = 4
      color = 'B'
      board_find_row.send(:set_val, 0, col, color)
      result = board_find_row.send(:find_row, col)
      expect(result).to eq(1)
    end

    it 'returns nil if column full' do
      col = 4
      color = 'B'
      board_find_row.send(:set_val, 0, col, color)
      board_find_row.send(:set_val, 1, col, color)
      board_find_row.send(:set_val, 2, col, color)
      board_find_row.send(:set_val, 3, col, color)
      board_find_row.send(:set_val, 4, col, color)
      board_find_row.send(:set_val, 5, col, color)
      result = board_find_row.send(:find_row, col)
      expect(result).to be_falsy
    end
  end

  describe '#four_horz?' do
    subject(:board_four_horz) { described_class.new}

    it 'returns true if four horz of same color in first row' do
      color = 'B'
      board_four_horz.send(:set_val, 0, 0, color)
      board_four_horz.send(:set_val, 0, 1, color)
      board_four_horz.send(:set_val, 0, 2, color)
      board_four_horz.send(:set_val, 0, 3, color)
      result = board_four_horz.send(:four_horz?)
      expect(result).to be_truthy
    end

    it 'returns true if four horz of same color in second row' do
      color1 = 'B'
      color2 = 'W'
      board_four_horz.send(:set_val, 0, 0, color1)
      board_four_horz.send(:set_val, 0, 1, color2)
      board_four_horz.send(:set_val, 0, 2, color1)
      board_four_horz.send(:set_val, 0, 3, color2)
      board_four_horz.send(:set_val, 1, 0, color1)
      board_four_horz.send(:set_val, 1, 1, color1)
      board_four_horz.send(:set_val, 1, 2, color1)
      board_four_horz.send(:set_val, 1, 3, color1)
      result = board_four_horz.send(:four_horz?)
      expect(result).to be_truthy
    end

    it 'returns false if no horz of same color in empty board' do
      result = board_four_horz.send(:four_horz?)
      expect(result).to be_falsy
    end

    it 'returns false if no horz of same color in partially populated board' do
      color = 'B'
      board_four_horz.send(:set_val, 0, 0, color)
      result = board_four_horz.send(:four_horz?)
      expect(result).to be_falsy
    end
  end

  describe '#four_vert?' do
    subject(:board_four_vert) { described_class.new}
  
    it 'returns true if four vert of same color in first col' do
      color = 'B'
      board_four_vert.send(:set_val, 0, 0, color)
      board_four_vert.send(:set_val, 1, 0, color)
      board_four_vert.send(:set_val, 2, 0, color)
      board_four_vert.send(:set_val, 3, 0, color)
      result = board_four_vert.send(:four_vert?)
      expect(result).to be_truthy
    end
  
    it 'returns true if four vert of same color in second col' do
      color1 = 'B'
      color2 = 'W'
      board_four_vert.send(:set_val, 0, 0, color1)
      board_four_vert.send(:set_val, 1, 0, color2)
      board_four_vert.send(:set_val, 2, 0, color1)
      board_four_vert.send(:set_val, 3, 0, color2)
      board_four_vert.send(:set_val, 0, 1, color1)
      board_four_vert.send(:set_val, 1, 1, color1)
      board_four_vert.send(:set_val, 2, 1, color1)
      board_four_vert.send(:set_val, 3, 1, color1)
      result = board_four_vert.send(:four_vert?)
      expect(result).to be_truthy
    end
  
    it 'returns false if no vert of same color in empty board' do
      result = board_four_vert.send(:four_vert?)
      expect(result).to be_falsy
    end
  
    it 'returns false if no vert of same color in partially populated board' do
      color = 'B'
      board_four_vert.send(:set_val, 0, 0, color)
      result = board_four_vert.send(:four_vert?)
      expect(result).to be_falsy
    end
  end

  describe '#four_diag?' do
    subject(:board_four_diag) { described_class.new}
    
    it 'returns true if four diag, right, anywhere on board' do
      color = 'B'
      board_four_diag.send(:set_val, 0, 0, color)
      board_four_diag.send(:set_val, 1, 1, color)
      board_four_diag.send(:set_val, 2, 2, color)
      board_four_diag.send(:set_val, 3, 3, color)
      result = board_four_diag.send(:four_diag?)
      expect(result).to be_truthy
    end

    it 'returns true if four diag, left, anywhere on board' do
      color = 'B'
      board_four_diag.send(:set_val, 0, 3, color)
      board_four_diag.send(:set_val, 1, 2, color)
      board_four_diag.send(:set_val, 2, 1, color)
      board_four_diag.send(:set_val, 3, 0, color)
      result = board_four_diag.send(:four_diag?)
      expect(result).to be_truthy
    end
    
    it 'returns false if no diag of same color in empty board' do
      result = board_four_diag.send(:four_diag?)
      expect(result).to be_falsy
    end
    
    it 'returns false if no diag of same color in partially populated board' do
      color = 'B'
      board_four_diag.send(:set_val, 0, 0, color)
      result = board_four_diag.send(:four_diag?)
      expect(result).to be_falsy
    end
  end

  describe '#board_full?' do
    subject(:board_full) { described_class.new}

    it 'returns false if board empty' do
      result = board_full.send(:board_full?)
      expect(result).to be_falsy
    end

    it 'returns false if board partially full' do
      board_full.send(:set_val, 0, 0, 'B')
      result = board_full.send(:board_full?)
      expect(result).to be_falsy
    end

    it 'returns true if board full' do
      (0..5).each do |row|
        (0..6).each do |col|
          board_full.send(:set_val, row, col, 'B')
        end
      end
      result = board_full.send(:board_full?)
      expect(result).to be_truthy
    end
  end

end

describe Game do

  describe '#get_move' do
    subject(:game_get_move) { described_class.new }

    it 'returns a move from player input' do

    end

  end

  describe '#valid_move?' do
    subject(:game_valid_move) { described_class.new }

    it 'returns true if move valid' do
      move = '3'
      result = game_valid_move.send(:valid_move?, move)
      expect(result).to be_truthy
    end

    it 'returns false if move not a number' do
      move = 'a'
      result = game_valid_move.send(:valid_move?, move)
      expect(result).to be_falsy
    end

    it 'returns false if move greater than 6' do
      move = '7'
      result = game_valid_move.send(:valid_move?, move)
      expect(result).to be_falsy
    end

    it 'returns false if move less than 0' do
      move = '-1'
      result = game_valid_move.send(:valid_move?, move)
      expect(result).to be_falsy
    end

    it 'returns false if col full' do
      6.times { game_valid_move.send(:make_move, 4, 'B') }
      result = game_valid_move.send(:valid_move?, '4')
      expect(result).to be_falsy
    end

  end

  describe '#switch_turns' do
    subject(:game_switch) { described_class.new }

    it 'switches from player2 to player1' do
      player2 = game_switch.instance_variable_get(:@player2) 
      player1 = game_switch.instance_variable_get(:@player1) 
      result = game_switch.send(:switch_turns, player2)
      expect(result).to eq(player1)
    end
  end

end

describe Player do

  # No tests needed

end