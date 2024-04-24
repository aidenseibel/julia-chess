include("piece.jl")
include("move.jl")
include("game.jl")
include("engine.jl")
include("puzzles.jl")

function two_player(game::Game)
    # while both players have their kings
    while isnothing(winner(game))
        println(to_string(game))    # print the current game
        
        # parse a move from input
        println("Enter a move for " * string(game.player_to_move) * " (in format e2e4, \"quit\" to quit): ")
        move_string = readline()

        if move_string == "quit" 
            println("Exiting game...\n\n")
            return 
        end

        move = move_from_string(move_string)

        # ensure the move is valid before proceeding
        while !is_valid_move(game, move)
            println("Move is not valid. Try again!")
            println("Enter a move for " * string(game.player_to_move) * " (in format e2e4, \"quit\" to quit): ")
        end


        # make the move
        make_move!(game, move)
        
    end

    # print final board and winner
    println(to_string(game))
    println(string(winner(game)) * " is the winner!")
end

# allows a player to play the engine.
function play_engine(game::Game, depth::Int64)
    current_turn = 1
    # while both players have their kings
    while isnothing(winner(game))
        println(to_string(game))    # print the current game
        
        # parse a move from input
        println("Enter a move for " * string(game.player_to_move) * " (in format e2e4, \"quit\" to quit): ")
        move_string = readline()

        if move_string == "quit" 
            println("Exiting game...\n\n")
            return 
        end

        move = move_from_string(move_string)

        # ensure the move is valid before proceeding
        while !is_valid_move(game, move)
            println("Move is not valid. Try again!")
            println("Enter a move for " * string(game.player_to_move) * " (in format e2e4, \"quit\" to quit): ")
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
            engine_move, engine_rating::Int64 = get_best_move(depth, game)
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

# allows users to select a depth
function get_depth_input()::Int64
    print("\n\nChoose an engine depth: \n - depth 3 (instant)\n - depth 4 (recommended)\n - depth 5 (accurate, but very slow)\n\nSelect setting (3/4/5): ")
    depth = readline()

    while !(depth in ["3", "4", "5"])
        print("\nInvalid choice. Select depth (3/4/5): ")
        depth = readline()
    end

    return parse(Int64, depth)
end

function main()
    println("A Julia Chess Project, written by Aiden Seibel, Samuel Pappas, Janet Jiang, and Cole Lee.\n")
    choice = ""
    
    while choice != "4"
        print("Options: \n(1) play a two-player game\n(2) play the engine\n(3) test the engine accuracy (elo)\n(4) quit\n\nSelect option: ")
        choice = readline()
        
        if choice == "1"
            two_player(initial_game())

        elseif choice == "2"
            depth = get_depth_input()
            play_engine(initial_game(), depth)

        elseif choice == "3"
            depth = get_depth_input()
            print("Enter number of puzzles (1-100): ")
            num_puzzles = tryparse(Int, readline())
            
            while !(num_puzzles isa Int && 1 <= num_puzzles <= 100)
                print("\nInvalid input. Enter number of puzzles (1-100): ")
            end
            
            estimate_engine_elo("puzzles.csv", num_puzzles, depth)

        elseif choice == "4"
            continue
        else
            println("Invalid choice.")
        end
    end

    println("Bye")
end

main()