include("piece.jl")
include("move.jl")
include("game.jl")

using Random 

# from a given game, return the best move and the board evaluation.
function get_best_move(depth::Int64, game::Game, play_random::Bool)::Tuple{Union{Move, Nothing}, Int64}
    # base case, depth is 0 so we stop evaluating
    if depth <= 0 return (nothing, evaluate_material(game)) end

    # initialize a tuple with an empty move and the worst possible evaluation for the current player's color
    best_move_and_evaluation::Tuple{Union{Move, Nothing}, Int64} = (game.player_to_move == White ? (nothing, -100000) : (nothing, 100000))
    
    # iterate through all the legal moves generated
    for move::Move in get_all_legal_moves(game)
        # in order to evaluate a move, we make the move on the board, consider the position, and then unmake it
        captured_piece::Union{Piece, Nothing} = make_move!(game, move)  # we keep the captured piece to add back later 

        # recursive call returns the best move/rating from the next state
        best_this_branch::Tuple{Union{Move, Nothing}, Int64} = get_best_move(depth - 1, game, play_random)   # note depth - 1 will lead to base case eventually

        # if we find a move with a better rating than what we currently have, replace the current move.
        # "better rating" is more positive for white, more negative for black.
        # keep in mind the player was flipped earlier when we made the initial move; we take this into account.
        if game.player_to_move == White && best_this_branch[2] < best_move_and_evaluation[2]
            best_move_and_evaluation = (move, best_this_branch[2])
        elseif game.player_to_move == Black && best_this_branch[2] > best_move_and_evaluation[2]
            best_move_and_evaluation = (move, best_this_branch[2])
        
        # this has been added to spice things up. if the move is equal to the current rating, 
        # there is a random chance that we pick it anyways. makes openings/endgames more interesting.
        # of course, there's the engine plays slower as a result.
        elseif best_this_branch[2] == best_move_and_evaluation[2] && play_random && rand() < 0.20 
            best_move_and_evaluation = (move, best_this_branch[2])
        end
        
        # after evaluating a given move, "unmake" it
        un_make_move!(game, move, captured_piece)   # using the captured piece from earlier
    end

    return best_move_and_evaluation
end

# allow the engine to play openings, making it more interesting at the start.
function get_opening(game::Game)::Union{Move, Nothing}
    if game.player_to_move == White
        potential_moves = ["e2e4", "d2d4", "c2c4", "f2f4", "g1f3", "b1c3", "b2b3", "g2g3"]
    else
        potential_moves = ["e7e5", "d7d5", "c7c5", "c7c6", "g8f6", "b8f6", "b7b6", "g7g6"]
    end

    for _ in 1:10
        consider_move = move_from_string(rand(potential_moves))
        if is_valid_move(game, consider_move)
            return consider_move 
        end
    end

    return nothing
end

# get_best_move(4, initial_game(), true)