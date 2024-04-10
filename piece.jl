# an enumeration for piece/player colors.
@enum Color begin
    Black
    White
end

# utility function - returns the opposite color.
function opponent(color::Color)::Color
    if color == Black return White end
    return Black
end

# an enumeration to specify piece types.
@enum PieceType begin
    Pawn
    Bishop
    Knight
    Rook
    Queen
    King
end

# ------------------------------------------------------------------------------------------------------------------

# a piece must have at least a color and a type; everything else can be derived.
mutable struct Piece
    color::Color
    type::PieceType
end

# returns an integer value based on the piecetype and color. Should be negative if black.
function value(piece::Piece)::Int
    piece_value::Int64 = 0
    if piece.type == Pawn
        piece_value = 1
    elseif piece.type == Knight || piece.type == Bishop
        piece_value = 3
    elseif piece.type == Rook
        piece_value = 5
    elseif piece.type == Queen
        piece_value = 9
    elseif piece.type == King
        piece_value = 10000
    end

    if piece.color == Black
        return -piece_value
    else 
        return piece_value
    end
end

# returns a character value based on the piecetype and color. Should be lowercase if black.
function to_string(piece::Piece)::String
    piece_string::String = ""
    if piece.color == Black
        if piece.type == Pawn
            piece_string = "♙"
        elseif piece.type == Knight
            piece_string = "♘"
        elseif piece.type == Bishop
            piece_string = "♗"
        elseif piece.type == Rook
            piece_string = "♖"
        elseif piece.type == Queen
            piece_string = "♕"
        elseif piece.type == King
            piece_string = "♔"
        end
        return piece_string
    else 
        if piece.type == Pawn
            piece_string = "♟︎"
        elseif piece.type == Knight
            piece_string = "♞"
        elseif piece.type == Bishop
            piece_string = "♝"
        elseif piece.type == Rook
            piece_string = "♜"
        elseif piece.type == Queen
            piece_string = "♛"
        elseif piece.type == King
            piece_string = "♚"
        end
        return piece_string
    end
end


# ------------------------------------------------------------------------------------------------------------------

# # for testing purposes

# println(to_string(Piece(Black, Pawn)))
# println(value(Piece(Black, Pawn)))