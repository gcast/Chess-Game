# encoding: utf-8
class SlidingPiece < Piece

  def moves
    super(7)
  end

end


class Queen < SlidingPiece

  def move_dirs
    VERTIZONTAL + DIAGONAL
  end

  def display
    color == :w ? "\u{2655} " : "\u{265B} "
  end

end


class Bishop < SlidingPiece

  def move_dirs
    DIAGONAL
  end

  def display
    color == :w ? "\u{2657} " : "\u{265D} "
  end

end


class Rook < SlidingPiece

  attr_reader :has_moved

  def initialize(board, pos, color)
    super(board, pos, color)
    @has_moved = false
  end

  def pos=(arr)
    @pos = arr
    @has_moved = true
  end

  def move_dirs
    VERTIZONTAL
  end

  def display
    color == :w ? "\u{2656} " : "\u{265C} "
  end

end