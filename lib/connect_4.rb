require 'pry-byebug'

# Class that hold the game logic and play commands
class Game

  POSSIBLE_MOVES = ['0', '1', '2', '3', '4', '5', '6']

  def initialize
    @player1 = nil
    @player2 = nil
    @starting_player = @player2 #start as player 2, but switch turns immediately happens
    @board = Board.new
  end

  def get_name
    name = gets.chomp
    while name == ''
      puts 'Name cannot be blank, try again:'
      name = gets.chomp
    end
    name
  end

  def new_game
    system('clear')
    set_players # Moved out of initialize to make testing not glitchy
    play
  end

  private

  def play
    current_turn = @starting_player
    until game_over?
      system('clear')
      @board.display
      current_turn = switch_turns(current_turn)
      puts "#{current_turn.name}#{current_turn.symbol}, enter column (0-6) to make move:"
      move = get_move
      make_move(move, current_turn.color)
    end
    system('clear')
    @board.display
    puts display_result(current_turn)
    play_again?
  end

  def set_players
    puts 'Enter player 1 name:'
    player1 = get_name
    @player1 = Player.new(player1, 'B')
    puts 'Enter player 2 name:'
    player2 = get_name
    @player2 = Player.new(player2, 'W')
    @starting_player = @player2 #start as player 2, but switch turns immediately happens
  end

  def game_over?
    return true if @board.board_full? or @board.four_in_series?
    false
  end

  def get_move
    move = gets.chomp
    until valid_move?(move)
      puts 'Invalid move, try again:'
      move = gets.chomp
    end
    move.to_i
  end

  def valid_move?(move)
    # binding.pry
    return false unless POSSIBLE_MOVES.include?(move)
    move = move.to_i
    return false unless @board.find_row(move)
    true
  end

  def make_move(move, color)
    @board.make_move(move, color)
  end

  def switch_turns(current_turn)
    return @player1 if current_turn == @player2
    @player2
  end

  def display_result(current_turn)
    return 'Tie!' if @board.board_full?
    current_turn.wins += 1
    return "#{current_turn.name}#{current_turn.symbol} wins!"
  end

  def play_again?
    puts "Total #{@player1.name} wins: #{@player1.wins}"
    puts "total #{@player2.name} wins: #{@player2.wins}"
    puts 'Play again? Enter Y/N:'
    answer = gets.chomp.upcase
    until answer == 'Y' || answer == 'N'
      puts 'Must enter Y/N, try again:'
      answer = gets.chomp.upcase
    end
    if answer == 'Y'
      @board.reset
      @starting_player = switch_turns(@starting_player)
      play
      return
    end
    puts 'Thanks for playing!'
  end

end

# Class that has the player information
class Player
  
  attr_reader :name, :color
  attr_accessor :wins

  def initialize(name, color)
    @name = name
    @color = color
    @wins = 0
  end

  def symbol
    if @color == 'B'
      return "\u26AB"
    else
      return "\u26AA"
    end
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
    puts " 0  1  2  3  4  5  6"
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

  def board_full?
    @grid.flatten.none?(nil)
  end

  def find_row(col)
    @grid.each_with_index do |row_values, row_num|
      val = row_values[col]
      return row_num if val.nil? 
    end
    nil
  end

  private

  def set_val(row, col, color)
    @grid[row][col] = color
    color
  end
  
  def get_val(row, col)
    @grid[row][col]
  end

  def four_horz?
    @grid.each do |row|
      count = 0
      color = nil
      row.each do |val|
        if val.nil? || val != color
          count = 0
        else
          count += 1
          return true if count == 3
        end
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
        if val.nil? || val != color
          count = 0
        else
          count += 1
          return true if count == 3
        end
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
    count = 0
    until col < 0 || row > 5
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
    count = 0
    until col > 6 || row > 5
      val = get_val(row, col)
      return false if val != color
      count += 1
      return true if count == 4
      row += 1
      col += 1 #right diag
    end
    false
  end

end

g = Game.new
g.new_game