include("piece.jl")
include("move.jl")
include("game.jl")

# from a given game, return the best move and the board evaluation.
function get_best_move(depth::Int64, game::Game)::Tuple{Move, Int64}
    # base case, depth is 0 so we stop evaluating
    if depth <= 0 return evaluate_material(game) end

    # initialize a tuple with an empty move and the worst possible evaluation for the current player's color
    best_move_and_evaluation::Tuple{Move, Int64} = (game.player_to_move == White ? (nothing, -10000) : (nothing, 10000))
    
    # iterate through all the legal moves generated
    for move::Move in get_all_legal_moves(game)
        # in order to evaluate a move, we make the move on the board, consider the position, and then unmake it
        captured_piece::Piece = make_move!(game, move)  # we keep the captured piece to add back later 

        # recursive call returns the best move/rating from the next state
        best_this_branch::Tuple{Move, Int64} = get_best_move(depth - 1, game)   # note depth - 1 will lead to base case eventually

        # if we find a move with a better rating than what we currently have, replace the current move.
        # "better rating" is more positive for white, more negative for black
        if game.player_to_move == White && best_this_branch[2] > best_move_and_evaluation[2]
            best_move_and_evaluation = best_this_branch
        elseif game.player_to_move == Black && best_this_branch[2] < best_move_and_evaluation[2]
            best_move_and_evaluation = best_this_branch
        end
        
        # after evaluating a given move, "unmake" it
        un_make_move!(game, move, captured_piece)   # using the captured piece from earlier
    end
end

# similar to get_best_move(), but only returns the board evalution, not a move. slightly faster by consequence.
function get_evaluation(depth::Int64, game::Game)::Int64
    if depth == 0 return evaluate_material(game) end

    current_eval = game.player_to_move == White ? -10000 : 10000
    
    for move::Move in get_all_legal_moves(game)
        # in order to evaluate a move, we make the move on the board, consider the position, and then unmake it
        captured_piece::Piece = make_move!(game, move)  # we keep the captured piece to add back later 

        # recursive call
        best_this_branch::Int64 = get_evaluation(depth - 1, game)

        # update the evaluation
        if game.player_to_move == White
            current_eval = max(current_eval, best_this_branch)
        else
            current_eval = min(current_eval, best_this_branch)
        end
        
        # after evaluating a given move, "unmake" it
        un_make_move!(game, move, captured_piece)   # using the captured piece from earlier
    end
end