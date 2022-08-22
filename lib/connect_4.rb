# Class that hold the game logic and play commands
class Game

  def initialize(player1 = 'Bert', player2 = 'Rob')
    @player1 = Player.new(player1, 'B')
    @player2 = Player.new(player2, 'W')
    @board = Board.new
  end

  def play

  end

  def game_over?

  end

end

# Class that has the player information
class Player
  
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

end

# Class that has the holds and changes the board data
class Board

  def initialize
    @grid = Array.new(6) { Array.new(7, nil) }
  end

  def display
    puts "----------------------"
    @grid.reverse_each do |row|
      display_row = ""
      row.each do |value|
        if value == 'B'
          symbol = "\u26AB"
        elsif value == 'W'
          symbol = "\u26AA"
        else 
          symbol = '  '
        end
        display_row += "|#{symbol}"
      end
      puts display_row + "|"
      puts "----------------------"
    end
  end

  def reset
    @grid = Array.new(6) { Array.new(7, nil) }
  end

  def make_move(col, color)
    row = find_row(col)
    return false if row.nil?
    set_val(row, col, color)
  end

  # No need to return what color, can find that by looking at last move
  def four_in_series?
    return true if four_horz? || four_vert? || four_diag?
    false
  end

  private

  def set_val(row, col, color)
    @grid[row][col] = color
    color
  end
  
  def get_val(row, col)
    @grid[row][col]
  end

  def find_row(col)
    @grid.each_with_index do |row_values, row_num|
      val = row_values[col]
      return row_num if val.nil? 
    end
    nil
  end

  def four_horz?
    @grid.each do |row|
      count = 0
      color = nil
      row.each do |val|
        next if val.nil?
        count += 1 if color.nil? || color == val 
        return true if count == 4
        color = val
      end
    end
    false
  end

  def four_vert?
    transposed_grid = @grid.transpose() # Can use same algo as four_horz? by transposing grid
    transposed_grid.each do |row|
      count = 0
      color = nil
      row.each do |val|
        next if val.nil?
        count += 1 if color.nil? || color == val 
        return true if count == 4
        color = val
      end
    end
    false
  end

  def four_diag?
    @grid.each_with_index do |row_values, row|
      row_values.each_with_index do |val, col|
        next if val.nil?
        return true if right_diag?(row, col, val) || left_diag?(row, col, val)
      end
    end
    false
  end

  def left_diag?(row, col, color)
    count = 1
    until col < 0
      val = get_val(row, col)
      return false if val != color
      count += 1
      return true if count == 4
      row += 1
      col -= 1 #left diag
    end
    false
  end

  def right_diag?(row, col, color)
    count = 1
    until col > 5
      val = get_val(row, col)
      return false if val != color
      count += 1
      return true if count == 4
      row += 1
      col += 1 #right diag
    end
    false
  end

  def board_full?
    @grid.flatten.none?(nil)
  end

end