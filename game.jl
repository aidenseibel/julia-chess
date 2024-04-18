include("piece.jl")
import Base.:(==)

# a game must include a board as well as the player to move; 
# some things are still necessary, such as castling rights and en passant rules, 
# but we should ignore those for simplicity for now.
mutable struct Game
    board::Matrix{Union{Piece, Nothing}} # best version of an Option for now
    player_to_move::Color
end

# iterates through every square in the board and totals the material only. Should be as fast as possible.
function evaluate_material(game::Game)::Int64
    material_count::Int64 = 0
    for row in 1:8
        for column in 1:8
            if isa(game.board[row, column], Piece)
                material_count += value(game.board[row, column])
            end
        end
    end

    return material_count
end

# checks to see if any kings are not present on the board, returns opposite player, else returns nothing.
function winner(game::Game)::Union{Color, Nothing}
    material = evaluate_material(game) 
    if material > 9000
        return Black
    elseif material < -9000
        return White
    else return nothing end
end

# returns the current player to move and the board. 
function to_string(game::Game)::String
    game_string::String = "Color to move: "

    # current player to move
    if game.player_to_move == Black
        game_string *= "Black\n---------------------------------\n" # formatting
    else
        game_string *= "White\n---------------------------------\n" # formatting
    end

    # current board
    for row in 8:-1:1
        game_string *= "| "
        for column in 1:8
            if isa(game.board[row, column], Piece)
                game_string *= to_string(game.board[row, column])
            else
                game_string *= " "
            end
            game_string *= " | " # formatting
        end
        game_string *= string(row)
        game_string *= "\n---------------------------------\n" # formatting
    end
    game_string *= "  a   b   c   d   e   f   g   h "

    return game_string
end

# intializes a new game with the starting position, with white to move.
function initial_game()::Game
    game = Game(fill(nothing, 8, 8), White)

    game.board[8, 1] = Piece(Black, Rook)
    game.board[8, 2] = Piece(Black, Knight)
    game.board[8, 3] = Piece(Black, Bishop)
    game.board[8, 4] = Piece(Black, Queen)
    game.board[8, 5] = Piece(Black, King)
    game.board[8, 6] = Piece(Black, Bishop)
    game.board[8, 7] = Piece(Black, Knight)
    game.board[8, 8] = Piece(Black, Rook)
    
    for i in 1:8
        game.board[7, i] = Piece(Black, Pawn)
    end

    for i in 1:8
        game.board[2, i] = Piece(White, Pawn)
    end
    
    game.board[1, 1] = Piece(White, Rook)
    game.board[1, 2] = Piece(White, Knight)
    game.board[1, 3] = Piece(White, Bishop)
    game.board[1, 4] = Piece(White, Queen)
    game.board[1, 5] = Piece(White, King)
    game.board[1, 6] = Piece(White, Bishop)
    game.board[1, 7] = Piece(White, Knight)
    game.board[1, 8] = Piece(White, Rook)
    
    return game
end

# read a string of FEN (Forsyth–Edwards Notation) and output a new game.
# example FEN (initial game): rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
function game_from_fen(fen::String)::Game
    fen_board, fen_player, _, _, _, _ = split(fen, " ") # we will ignore castling rights, en passant rules, etc for now

    game_player = fen_player == "w" ? White : Black # read the player to move

    game_board::Matrix{Union{Piece, Nothing}} = fill(nothing, 8, 8)
    
    # populate the game board
    rows = split(fen_board, "/")
    for row in 1:8
        current_column::Int64 = 1
        for character in rows[row]
            # if there is a number, there is an n-square gap in the row
            if character in ['1', '2', '3', '4', '5', '6', '7', '8']
                current_column += parse(Int64, character)
            
            # otherwise, parse the piece and add it to the board
            else
                game_board[9-row, current_column] = get_piece(character)
                current_column += 1
            end
        end
    end

    return Game(game_board, game_player)
end

# returns if two games have the same board and player to move, for testing purposes.
function ==(game1::Game, game2::Game)::Bool
    # check the player to move
    if game1.player_to_move != game2.player_to_move return false end

    # check the board
    for row in 1:8
        for column in 1:8
            if game1.board[row, column] != game2.board[row, column] return false end
        end
    end

    return true
end


# ------------------------------------------------------------------------------------------------------------------

# # for testing purposes
# a = initial_game()
# println(to_string(a))

# e4_fen = "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"
# println(to_string(game_from_fen(e4)))