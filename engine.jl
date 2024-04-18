include("piece.jl")
include("move.jl")
include("game.jl")

# from a given game, return the best move and the board evaluation.
function get_best_move(depth::Int64, game::Game)::Tuple{Union{Move, Nothing}, Int64}
    # base case, depth is 0 so we stop evaluating
    if depth <= 0 return (nothing, evaluate_material(game)) end

    # initialize a tuple with an empty move and the worst possible evaluation for the current player's color
    best_move_and_evaluation::Tuple{Union{Move, Nothing}, Int64} = (game.player_to_move == White ? (nothing, -100000) : (nothing, 100000))
    
    # iterate through all the legal moves generated
    for move::Move in get_all_legal_moves(game)
        # in order to evaluate a move, we make the move on the board, consider the position, and then unmake it
        captured_piece::Union{Piece, Nothing} = make_move!(game, move)  # we keep the captured piece to add back later 

        # recursive call returns the best move/rating from the next state
        best_this_branch::Tuple{Union{Move, Nothing}, Int64} = get_best_move(depth - 1, game)   # note depth - 1 will lead to base case eventually

        # if we find a move with a better rating than what we currently have, replace the current move.
        # "better rating" is more positive for white, more negative for black
        
        if game.player_to_move == White && best_this_branch[2] < best_move_and_evaluation[2]
            best_move_and_evaluation = (move, best_this_branch[2])
        elseif game.player_to_move == Black && best_this_branch[2] > best_move_and_evaluation[2]
            best_move_and_evaluation = (move, best_this_branch[2])
        end
        
        # after evaluating a given move, "unmake" it
        un_make_move!(game, move, captured_piece)   # using the captured piece from earlier
    end

    return best_move_and_evaluation
end


# # println(get_all_legal_moves(initial_game()))
# println(to_string(initial_game()))
# println("Best move (depth 1): ", get_best_move(1, initial_game()))
# println("Best move (depth 2): ", get_best_move(2, initial_game()))
# println("Best move (depth 3): ", get_best_move(3, initial_game()))
# println("Best move (depth 4): ", get_best_move(4, initial_game()))
# println("Best move (depth 5): ", get_best_move(5, initial_game()))
# println("Best move (depth 6): ", get_best_move(6, initial_game()))