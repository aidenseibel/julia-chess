include("piece.jl")
include("move.jl")
include("game.jl")
include("engine.jl")

using CSV
using Random
using DataFrames

# selects a random puzzle and returns whether the engine solved it.
function test_puzzle(fen::String, best_move::String, depth::Int64)::Bool
    # create a game from the fen
    game::Game = game_from_fen(fen)

    # get the engine's best move
    engine_best_move, _ = get_best_move(depth, game)

    # compare to the actual best move
    if to_string(engine_best_move) == best_move
        printstyled("Solved!", color=:green)
        println(" Engine move ", to_string(engine_best_move), ", Best move", best_move)
        return true
    else
        printstyled("Failed.", color=:red)
        println(" Engine move ", to_string(engine_best_move), ", Best move", best_move)
        return false
    end
end

# using puzzles.csv, read in games via fen and calculate the engine's ELO.  
function estimate_engine_elo(puzzle_file_path::String, num_puzzles::Int64, depth::Int64)::Float64
    println("\n\n--------------------PUZZLES--------------------")
    all_puzzles = CSV.read(puzzle_file_path, DataFrame) # read puzzles as a dataframe from csv
    num_rows = size(all_puzzles, 1)
    
    num_correct = 0
    elo = 1400  # our base strength, which will get updated as puzzles are solved/not solved
    kfactor = 500   # the amount that we change our base strength, which diminishes over time
    highest_problem_solved = 0

    for i in 1:num_puzzles+1
        id, fen::String, best_move::String, puzzle_rating::Int64 = all_puzzles[rand(1:num_rows), :] # pattern match on a random puzzle 
        print("#", string(i), ", id: ", id, " rating: ", string(puzzle_rating), "...")
        did_solve = test_puzzle(fen, best_move, depth)      # get the result as a boolean
        
        # julia allowing us to treat booleans as 1 / 0 allows easy math
        num_correct += did_solve
        elo += kfactor * (did_solve - 1 / (1 + 10^( (puzzle_rating - elo) / 400.0)));   # recalculate elo
        kfactor = max(32, (kfactor * 0.80))                                             # change the kfactor
        highest_problem_solved = max(highest_problem_solved, puzzle_rating * did_solve)
        println("New elo = ", string(elo))
    end

    # results
    println("\n\n--------------------RESULTS--------------------")
    println(num_puzzles, " puzzles attempted, ", num_correct, " correct, ", num_puzzles-num_correct, " incorrect")
    println("Highest problem solved: ", highest_problem_solved)
    println("Estimated engine ELO: ", round(elo), "\n\n")

    return elo
end