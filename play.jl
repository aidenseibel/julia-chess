include("piece.jl")
include("move.jl")
include("game.jl")
include("engine.jl")

function two_player(game::Game)
    # while both players have their kings
    while isnothing(winner(game))
        println(to_string(game))    # print the current game
        
        # parse a move from input
        println("Enter a move for " * string(game.player_to_move) * " (in format e2e4): ")
        move = move_from_string(readline())

        # ensure the move is valid before proceeding
        while !is_valid_move(game, move)
            println("Move is not valid. Try again!")
            println("Enter a move for " * string(game.player_to_move) * " (in format e2e4): ")
            move = move_from_string(readline())
        end

        # make the move
        make_move!(game, move)
        
    end

    # print final board and winner
    println(to_string(game))
    println(string(winner(game)) * " is the winner!")
end

# allows a player to play the engine.
function play_engine(game::Game)
    current_turn = 1
    # while both players have their kings
    while isnothing(winner(game))
        println(to_string(game))    # print the current game
        
        # parse a move from input
        println("Enter a move for " * string(game.player_to_move) * " (in format e2e4): ")
        move = move_from_string(readline())

        # ensure the move is valid before proceeding
        while !is_valid_move(game, move)
            println("Move is not valid. Try again!")
            println("Enter a move for " * string(game.player_to_move) * " (in format e2e4): ")
            move = move_from_string(readline())
        end

        # make the move
        make_move!(game, move)
        println(to_string(game))
        sleep(1)
        println("Calculating engine move...")
        
        # if it's the first move, consider playing an opening
        engine_move::Union{Move, Nothing} = nothing
        if current_turn == 1
            engine_move = get_opening(game)
        else
            engine_move, engine_rating::Int64 = get_best_move(4, game, true)
        end

        # make the engine move
        make_move!(game, engine_move)
        println("Engine plays ", to_string(engine_move))
        
        # increase the current turn
        current_turn += 1
    end

    # print final board and winner
    println(to_string(game))
    println(string(winner(game)) * " is the winner!")    
end

# two_player(initial_game())
play_engine(initial_game())