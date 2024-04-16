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
    moving_piece::Piece = game.board[move.start_location[2], move.start_location[1]]

    # put down the moving piece at the end location
    game.board[move.end_location[2], move.end_location[1]] = moving_piece

    # remove the moving piece from its original location
    game.board[move.start_location[2], move.start_location[1]] = nothing

    # change the player to move 
    game.player_to_move = opponent(game.player_to_move)

    return captured_piece
end

function un_make_move(game::Game, move::Move, captured_piece::Union{Piece, Nothing})
    # "pick up" the moving piece at the END location
    moving_piece::Piece = game.board[move.end_location[1], move.end_location[2]]

    # put the captured piece at the END location
    game.board[move.end_location[1], move.end_location[2]] = captured_piece

    # "put down" the moving piece at the START location
    game.board[move.start_location[1], move.start_location[2]] = moving_piece

    # change back the player to move 
    game.player_to_move = opponent(game.player_to_move)    
end

# checks if a move is allowed given the present game state.
function is_valid_move(game::Game, move::Move)::Bool
    if isnothing(move) return false end
    
    # bounds check
    if !all(map(x -> x[1] in 1:8 && x[2] in 1:8, [move.start_location, move.end_location])) return false end

    # check if there is a piece at the starting location
    if isa(game.board[move.start_location[2], move.start_location[1]], Nothing) return false end

    # # check if there is nothing / a "captureable" piece at the end location (not our own)
    # if isa(game.board[move.end_location[1], move.end_location[2]], Nothing) return false end
    legals = get_all_legal_moves(game)
    #=print("\n\n Current possible moves: \n")
    print(legals)
    print("\nCurrent move:\n")
    print(move)
    print("\n\n")=#
    if move in legals
        # The move is in the list of legal moves
        return true
    else
        # The move is not in the list of legal moves
        return false
    end
end

# parses a Move from a String, returns nothing if fails
#=function move_from_string(s::String)::Union{Move, Nothing}
    if length(s) != 4 return nothing end    # quick validity check
    
    
    start_column, start_row, end_column, end_row = s    # lil pattern matching
    print(s)
    # parse, if fail return nothing
    try
        return Move((parse(Int, start_column), Int(start_row) - 96), (parse(Int, end_column), Int(end_row) - 96))
    catch
        println("Failed to parse move from string!")
        return nothing
    end
end=#
function move_from_string(s::String)::Union{Move, Nothing}
    if length(s) != 4
        return nothing  # quick validity check
    end
    
    # Extract individual characters from the string
    start_column = s[1]
    start_row = s[2]
    end_column = s[3]
    end_row = s[4]
    
    # Convert characters to integers
    try
        printMove = Move((Int(start_column) - 96, parse(Int, start_row)), (Int(end_column) - 96, parse(Int, end_row)))
        #print(printMove)
        return printMove
    catch
        println("Failed to parse move from string!")
        return nothing
    end
end


function is_valid_square(row, col)
    return 1 <= row <= 8 && 1 <= col <= 8
end


# returns all legal moves for a given piece. Note that since pieces 
# don't know their own location, it must be specified as an argument.
function get_piece_legal_moves(piece::Piece, location::Tuple{Int, Int}) 
    legal_moves = []
    legal_move_objects = []
    if piece.type == Pawn
        col, row = location #is this right?? or should it be backwards?
        direction = (piece.color == White) ? 1 : -1
        if is_valid_square(col, row + direction)
            #moveCol = Int(col) - 96
            push!(legal_moves, (col, row + direction))
            push!(legal_move_objects, (Move(location, (col, row + direction))))
        end
        setup_row = (piece.color == White) ? 2 : 7
        direction = (piece.color == White) ? 2 : -2
        if(setup_row == row)
            #moveCol = Int(start_column) - 96
            push!(legal_moves, (col, row + direction))
            push!(legal_move_objects, (Move(location, (col, row + direction))))
        end
        # Add code for pawn capturing diagonally
        # No need to check if the destination square is within the board boundaries or occupied by other pieces
    end

    if piece.type == Rook
        col, row = location
        for d_row in [-1, 1]  # Iterate over rows above and below the rook
            r = row + d_row
            while is_valid_square(col, r)
                push!(legal_moves, (col, r))
                push!(legal_move_objects, (Move(location, (col, r))))
                r += d_row
            end
        end
        for d_col in [-1, 1]  # Iterate over columns to the left and right of the rook
            c = col + d_col
            while is_valid_square(c, row)
                push!(legal_moves, (c, row))
                push!(legal_move_objects, (Move(location, (c, row))))
                c += d_col
            end
        end
    end

    if piece.type == Knight
        col, row = location
        for dc in [-2, -1, 1, 2]
            for dr in [-2, -1, 1, 2]
                if abs(dc) != abs(dr) && is_valid_square(col + dc, row + dr)
                    push!(legal_moves, (col + dc, row + dr))
                    push!(legal_move_objects, (Move(location, (col + dc, row + dr))))

                end
            end
        end
    end

    if piece.type == Bishop
        col, row = location
        for d_row in [-1, 1]  # Iterate over diagonals above and below the bishop
            for d_col in [-1, 1]
                r, c = row + d_row, col + d_col
                while is_valid_square(c, r)
                    push!(legal_moves, (c, r))
                    push!(legal_move_objects, (Move(location, (c, r))))
                    r += d_row
                    c += d_col
                end
            end
        end
    end

    if piece.type == Queen
        # The queen moves like a combination of a rook and a bishop
        col, row = location
        for d_row in [-1, 1]  # Iterate over rows above and below the queen
            r = row + d_row
            while is_valid_square(col, r)
                push!(legal_moves, (col, r))
                push!(legal_move_objects, (Move(location, (col, r))))
                r += d_row
            end
        end
        for d_col in [-1, 1]  # Iterate over columns to the left and right of the queen
            c = col + d_col
            while is_valid_square(c, row)
                push!(legal_moves, (c, row))
                push!(legal_move_objects, (Move(location, (c, row))))
                c += d_col
            end
        end
        for d_row in [-1, 1]  # Iterate over diagonals above and below the queen
            for d_col in [-1, 1]
                r, c = row + d_row, col + d_col
                while is_valid_square(c, r)
                    push!(legal_moves, (c, r))
                    push!(legal_move_objects, (Move(location, (c, r))))
                    r += d_row
                    c += d_col
                end
            end
        end
    end

    if piece.type == King
        col, row = location
        for d_row in [-1, 0, 1]
            for d_col in [-1, 0, 1]
                if (d_row != 0 || d_col != 0) && is_valid_square(col + d_col, row + d_row)
                    push!(legal_moves, (col + d_col, row + d_row))
                    push!(legal_move_objects, (Move(location, (col + d_col, row + d_row))))
                end
            end
        end
    end

    #return legal_moves
    return legal_move_objects
end

# returns all legal moves for all of a given player's pieces and a given board, by concatenating all legal moves
function get_all_legal_moves(game::Game)
    legal_moves = []
    
    # Iterate board
    for row in 1:8
        for col in 1:8
            piece = game.board[row, col]
            
            # Check if there is a piece on the current square
            if isa(piece, Piece) && piece.color == game.player_to_move
                # Get legal moves for the current piece
                piece_moves = get_piece_legal_moves(piece, (col, row))
                
                # Filter out illegal moves
                for move in piece_moves
                    dest_col, dest_row = move.end_location #does this work?
                    dest_piece = game.board[dest_row, dest_col]
                    
                    # Check if destination square is empty or occupied by opponent's piece
                    if isa(dest_piece, Nothing) || dest_piece.color != game.player_to_move
                        if piece.type == Pawn
                            if abs(dest_row - row) == 1 && abs(dest_col - col) == 1 # Check for diagonal attacks for pawns
                                if isa(dest_piece, Piece) && dest_piece.color != game.player_to_move
                                    #push!(legal_moves, (piece, move))
                                    push!(legal_moves, (move))
                                end
                            else  # regular pawn movement
                                if is_path_clear(game.board, (col, row), move.end_location)
                                    push!(legal_moves, (move))
                                end
                            end
                        else
                            # For other pieces, check if the path is clear
                            if is_path_clear(game.board, (col, row), move.end_location)
                                push!(legal_moves, (move))
                            end
                        end
                    end
                end
            end
        end
    end
    
    return legal_moves
end


function is_path_clear(board, start, dest)
    col_diff = dest[1] - start[1]
    row_diff = dest[2] - start[2]
    
    # Check if moving diagonally
    if col_diff != 0 && row_diff != 0 && abs(col_diff) == abs(row_diff)
        col_dir = sign(col_diff)
        row_dir = sign(row_diff)
        col = start[1] + col_dir
        row = start[2] + row_dir
        while (col, row) != dest
            if !isa(board[row, col], Nothing)
                return false
            end
            col += col_dir
            row += row_dir
        end
    # Check if moving horizontally or vertically
    elseif col_diff != 0 || row_diff != 0
        if col_diff != 0
            col_dir = sign(col_diff)
            col = start[1] + col_dir
            row = start[2]
            while col != dest[1]
                if !isa(board[row, col], Nothing)
                    return false
                end
                col += col_dir
            end
        else  # row_diff != 0
            row_dir = sign(row_diff)
            col = start[1]
            row = start[2] + row_dir
            while row != dest[2]
                if !isa(board[row, col], Nothing)
                    return false
                end
                row += row_dir
            end
        end
    end
    
    return true
end



# ------------------------------------------------------------------------------------------------------------------

# # for testing purposes
# a = initial_game()

# println(to_string(a.board[2, 5]))
# e4 = Move((2, 5), (4, 5))
# println(to_string(e4))
# make_move!(a, e4)

# println("\n\nAfter making move: \n" * to_string(a))