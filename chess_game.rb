require_relative './pieces.rb'
require_relative './board.rb'
require_relative './sliding_piece.rb'
require_relative './stepping_piece.rb'
require 'colorize'


class Game

  attr_accessor :board, :active_player

  def initialize
    @board = Board.new
    @active_player = :w
    board.setup_board
  end

  def play

    loop do
      board.render
      begin
        puts "#{active_player} to move.  What piece do you want to move: e.g. 0,0"
        print "> "
        from = gets.chomp.split(',').map { |x| x.to_i }
        puts "Where do you want to move this piece to? e.g. 1,1"
        print "> "
        to = gets.chomp.split(',').map { |x| x.to_i }
        board.move(from, to)
      rescue RuntimeError => e
        puts e.message
        retry
      end
      toggle_turn
      if board.checkmate?(active_player)
        puts "Checkmate, #{active_player} looses"
        break
      elsif
        board.in_check?(active_player)
        puts "#{active_player} in check."
      end
    end
  end

  def toggle_turn
    self.active_player = (active_player == :w ? :b : :w) # switch player
  end


end
