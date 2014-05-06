

class Piece

  #Move to respective classes
  VERTIZONTAL = [[0,1], [1,0], [0, -1], [-1, 0]]
  DIAGONAL = [[1,1], [-1,1], [-1,-1], [1,-1]]
  KNIGHT_MOVES = [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]
  PAWN_WHITE = {reg: [1,0], eat: [[1,-1],[1,1]]}
  PAWN_BLACK = {reg: [-1,0], eat: [[-1,1],[-1,-1]]}

  attr_accessor :board, :pos
  attr_reader :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    board.add_piece(self)
  end

  def moves(num_times)
    pos_moves = []
    self.move_dirs.each do |(dx, dy)|
      new_pos = self.pos
      num_times.times do
        new_pos = [dx + new_pos[0], dy + new_pos[1]]
        if board.in_range?(new_pos) && !board.has_piece?(new_pos)
          pos_moves << new_pos
        elsif board.in_range?(new_pos) && board.has_piece?(new_pos) && can_take?(new_pos)
          pos_moves << new_pos
          break
        end
      end
    end
    return pos_moves
  end

  def valid_moves
    moves.delete_if { |pos| move_into_check?(pos) }
    #generates error if play input is out of bounds
  end

  def can_take?(pos)
    self.color != board[pos].color
  end

  def move_into_check?(try_pos)
    start_pos = self.pos
    board_copy = board.dup
    board_copy.move!(start_pos, try_pos)
    board_copy.in_check?(self.color)
  end


end

