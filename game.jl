include("piece.jl")

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


# ------------------------------------------------------------------------------------------------------------------

# # for testing purposes
# a = initial_game()
# println(to_string(a))
