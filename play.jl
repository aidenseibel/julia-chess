include("piece.jl")
include("move.jl")
include("game.jl")

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

two_player(initial_game())