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


#TESTING
white_pawn = Piece(White, Pawn)
location = (2, 2)
println(get_piece_legal_moves(white_pawn, location))  # Should print [(2, 3), (2, 4)] for a white pawn on its starting row
black_pawn = Piece(Black, Pawn)
location = (1, 7)
println(get_piece_legal_moves(black_pawn, location))  # Should print [(1, 6), (1, 5)] for a black pawn on its starting row

rook = Piece(White, Rook)
location = (4, 7)
println(get_piece_legal_moves(rook, location)) 

knight = Piece(Black, Knight)
location = (6, 3)
println(get_piece_legal_moves(knight, location)) 
bishop = Piece(Black, Bishop)
location = (4, 4)
println(get_piece_legal_moves(bishop, location)) 

q = Piece(Black, Queen)
location = (4, 4)
println(get_piece_legal_moves(q, location)) 
println("\n\n")
println(get_all_legal_moves(initial_game()))
println("\n")
println(length(get_all_legal_moves(initial_game())))


two_player(initial_game())
