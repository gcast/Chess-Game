

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end


  def black_pieces
    grid.flatten.compact.select { |x| x.color == :b }
  end

  def white_pieces
    grid.flatten.compact.select { |x| x.color == :w }
  end

  # def []=(pos)
#     row, col = pos
#     board.grid[row][col]
#   end

  def has_piece?(pos)
    !grid[pos[0]][pos[1]].nil?
  end

  def has_color(pos)
    grid[pos[0]][pos[1]].color
  end

  def in_range?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def add_piece(piece_obj)
    grid[piece_obj.pos[0]][piece_obj.pos[1]] = piece_obj
  end

  def render
    puts " " + ("0".."7").to_a.join(" ")
    grid.each_with_index do |row, i|
      row_string = [i]
      row.each_with_index do |el, j|
        square = ( (i+j).even? ? :light_cyan : :light_red)
        row_string << (el.nil? ? "  ".colorize(:background => square) : el.display.colorize(:background => square))
      end
      puts row_string.join('')
    end
    nil
  end

  def setup_board
    King.new(self, [0, 3], :w)
    King.new(self, [7, 3], :b)
    8.times do |i|
      Pawn.new(self, [1,i], :w)
      Pawn.new(self, [6,i], :b)
    end
    2.times do |i|
      Rook.new(self, [0, i * 7], :w)
      Rook.new(self, [7, i * 7], :b)
      Knight.new(self, [0 , ((i * 7) - 1).abs ], :w)
      Knight.new(self, [7 , ((i * 7) - 1).abs], :b)
      Bishop.new(self, [0 , ((i * 7) - 2).abs ], :w)
      Bishop.new(self, [7 , ((i * 7) - 2).abs], :b)
    end
    Queen.new(self, [0, 4], :w)
    Queen.new(self, [7, 4], :b)
    render
  end

  def inspect
    render
  end

  def in_check?(color)
    target = kings_position(color)
    opposing_army = (color == :w ? black_pieces : white_pieces)

    opposing_army.each do |piece|
      return true if piece.moves.include?(target)
    end
    false
  end

  def kings_position(col)
    grid.flatten.compact.select { |x| x.class == King && x.color == col}.first.pos
  end

  def move!(start, end_pos) # makes move without checking if valid
    moving_piece = grid[start[0]][start[1]]
    if moving_piece.nil? || !in_range?(end_pos)
      raise "Invalid starting or ending location." #Rescue in play loop
    else
      if moving_piece.moves.include?(end_pos)
        moving_piece.pos = end_pos
        add_piece(moving_piece)
        grid[start[0]][start[1]] = nil
      end
    end
  end

  def move(start, end_pos)
    moving_piece = grid[start[0]][start[1]]
    if moving_piece.valid_moves.include?(end_pos)
      move!(start, end_pos)
    else
      raise "You can't move there"
    end
    # render
  end

  def dup
    new_board = Board.new

    self.white_pieces.each do |token|
      token_pos = token.pos
      token_color = token.color
      token.class.new(new_board,token_pos,token_color)
    end

    self.black_pieces.each do |token|
      token_pos = token.pos
      token_color = token.color
      token.class.new(new_board,token_pos,token_color)
    end
    new_board
  end

  def checkmate?(color)
    moving_army = (color == :w ? white_pieces : black_pieces)
    in_check?(color) && moving_army.all? { |token| token.valid_moves.empty? }
  end

  def can_castle?(col,type)
    which_rook = ( type == :kingside ? 0 : 1 )
    king = grid.flatten.compact.select { |x| x.class == King && x.color == col}.first
    rooks = grid.flatten.compact.select { |x| x.class == Rook && x.color == col}

    x, y = rooks[which_rook].pos
    if type == :kingside
      empty_between = grid[x][y + 1].nil? && grid[x][y + 2].nil?
    else
      empty_between = (grid[x][y - 1].nil? && grid[x][y - 2].nil?) && grid[x][y - 3].nil?
    end

    movement_state = !king.has_moved && !(rooks[which_rook].has_moved)

    empty_between && movement_state
  end

  def castle(col,type)

    row = (col == :w ? 0 : 7)

    if can_castle?(col, type)
      if type == :kingside
        king = grid[row][3]
        rook = grid[row][0]

        king.pos = [row,1]
        add_piece(king)
        grid[row][3] = nil

        rook.pos = [row,2]
        add_piece(rook)
        grid[row][0] = nil
      else
        king = grid[row][3]
        rook = grid[row][7]

        king.pos = [row,5]
        add_piece(king)
        grid[row][3] = nil

        rook.pos = [row,4]
        add_piece(rook)
        grid[row][7] = nil
      end

    else
      p "Sorry you can't castle #{type}" #raise error later
    end

  end

end

