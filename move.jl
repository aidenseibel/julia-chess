include("game.jl")
include("piece.jl")

# we do not need any other information than this.
struct Move 
    start_location::Tuple{Int, Int} # (row 1-8, column A-H)
    end_location::Tuple{Int, Int} # (row 1-8, column A-H)
end

# returns an easily readable string for a move in algebraic format, e.g. e2e4
function to_string(move::Move)::String
    start_location_string = string(Char(96 + move.start_location[2])) * string(move.start_location[1])
    end_location_string = string(Char(96 + move.end_location[2])) * string(move.end_location[1])

    return start_location_string * end_location_string
end

# given a game and a move, make the move. Note this mutates the game directly.
function make_move!(game::Game, move::Move)::Union{Piece, Nothing}
    if !is_valid_move(game, move)
        error("Move is not valid! Move: " * to_string(move) * "Game: \n" * to_string(game))
    end

    # remember the captured piece, if there is one
    captured_piece::Union{Piece, Nothing} = game.board[move.end_location[1], move.end_location[2]]

    # pick up the moving piece at the start location
    moving_piece::Piece = game.board[move.start_location[1], move.start_location[2]]

    # put down the moving piece at the end location
    game.board[move.end_location[1], move.end_location[2]] = moving_piece

    # remove the moving piece from its original location
    game.board[move.start_location[1], move.start_location[2]] = nothing

    # change the player to move 
    game.player_to_move = opponent(game.player_to_move)

    return captured_piece
end

# checks if a move is allowed given the present game state.
function is_valid_move(game::Game, move::Move)::Bool
    # bounds check
    if !all(map(x -> x[1] in 1:8 && x[2] in 1:8, [move.start_location, move.end_location])) return false end

    # check if there is a piece at the starting location
    if isa(game.board[move.start_location[1], move.start_location[2]], Nothing) return false end

    # # check if there is nothing / a "captureable" piece at the end location (not our own)
    # if isa(game.board[move.end_location[1], move.end_location[2]], Nothing) return false end

    return true
end

# utility 
is_valid_move(::Game, ::Nothing) = false

# parses a Move from a String, returns nothing if fails
function move_from_string(s::String)::Union{Move, Nothing}
    if length(s) != 4 return nothing end    # quick validity check
    
    start_column, start_row, end_column, end_row = s    # lil pattern matching
    
    # parse, if fail return nothing
    try
        return Move((parse(Int, start_row), Int(start_column) - 96), (parse(Int, end_row), Int(end_column) - 96))
    catch
        println("Failed to parse move from string!")
        return nothing
    end
end

# returns all legal moves for a given piece. Note that since pieces 
# don't know their own location, it must be specified as an argument.
function get_piece_legal_moves(piece::Piece, location::Tuple{Int, Int})
    return []
end

# returns all legal moves for a given player and board, by concatenating all legal moves
function get_all_legal_moves(game::Game)
    return []
end


# ------------------------------------------------------------------------------------------------------------------

# # for testing purposes
# a = initial_game()

# println(to_string(a.board[2, 5]))
# e4 = Move((2, 5), (4, 5))
# println(to_string(e4))
# make_move!(a, e4)

# println("\n\nAfter making move: \n" * to_string(a))