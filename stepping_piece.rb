# encoding: utf-8
class SteppingPiece < Piece

  def moves
    super(1)
  end

end

class Knight < SteppingPiece

  def move_dirs
    KNIGHT_MOVES
  end

  def display
    color == :w ? "\u{2658} " : "\u{265E} "
  end

end

class King < SteppingPiece

  attr_reader :has_moved

  def initialize(board, pos, color)
    super(board, pos, color)
    @has_moved = false
  end

  def move_dirs
    VERTIZONTAL + DIAGONAL
  end

  def display
    color == :w ? "\u{2654} " : "\u{265A} "
  end

  def pos=(arr)
    @pos = arr
    @has_moved = true
  end

end

class Pawn < SteppingPiece

  attr_reader :starting_row

  def initialize(board, pos, color)
    super(board, pos, color)

    nil
  end

  def move_dirs
    self.color == :w ? PAWN_WHITE : PAWN_BLACK
  end

  def moves
    starting_row = (color == :w ? 1 : 6)
    pos_moves = []
    num_times = (starting_row == pos[0] ? 2 : 1)
    new_pos = pos
    num_times.times do
      dx, dy = move_dirs[:reg]
      new_pos =[dx + new_pos[0], dy + new_pos[1]]
      if board.in_range?(new_pos) && !board.has_piece?(new_pos)
        pos_moves << new_pos
      else
        break
      end
    end


    move_dirs[:eat].each do |(dx, dy)|
      new_pos = [dx + pos[0], dy + pos[1]]
      pos_moves << new_pos if board.in_range?(new_pos) && board.has_piece?(new_pos) && can_take?(new_pos)
    end
    return pos_moves
  end

  def display
    color == :w ? "\u{2659} " : "\u{265F} "
  end


end