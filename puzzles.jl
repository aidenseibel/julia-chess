include("piece.jl")
include("move.jl")
include("game.jl")
include("engine.jl")

using CSV
using Random
using DataFrames

# selects a random puzzle and returns the puzzle rating accompanied by whether the engine solved it.
function test_puzzle(fen::String, best_move::String, depth::Int64)::Bool
    # create a game from the fen
    game::Game = game_from_fen(fen)

    # get the engine's best move
    engine_best_move, rating = get_best_move(depth, game)

    # compare to the actual best move
    if to_string(engine_best_move) == best_move
        println("Solved. ", "Engine:", to_string(engine_best_move), ", Best:", best_move)
        return true
    else
        println("Failed. ", "Engine:", to_string(engine_best_move), ", Best:", best_move)
        return false
    end
end

# using puzzles.csv, read in games via fen and output the engine accuracy based on  
function test_engine_accuracy(puzzle_file_path::String, num_puzzles::Int64, depth::Int64)::Float64
    all_puzzles = CSV.read(puzzle_file_path, DataFrame) # read puzzles as a dataframe from csv
    num_rows = size(all_puzzles, 1)
    
    count = 0

    for i in 1:num_puzzles
        id, fen::String, best_move::String, rating::Int64 = all_puzzles[rand(1:num_rows), :] # pattern match on a random puzzle 
        print("id: ", id, " rating: ", string(rating), "...")
        count += test_puzzle(fen, best_move, depth) # note that julia allows us to add booleans
    end

    return count / num_puzzles # calculate % puzzles solved
end

println("-----------Checkmate in one-----------")

test_puzzle("2r3k1/5pp1/1b1p3p/pN1Bp3/KP2P3/2q2P1P/R6P/3Q3R b - - 1 23", "c3b4", 4)
println("\n-----------Easy puzzles-----------")
test_engine_accuracy("puzzles/easy_puzzles.csv", 10, 4)

println("\n-----------All puzzles-----------")
test_engine_accuracy("puzzles/puzzles.csv", 10, 4)