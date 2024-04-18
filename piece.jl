import Base.:(==)

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

# from a FEN character, return the corresponding piece.
function get_piece(char::Char)::Piece
    if char == 'P'
        return Piece(White, Pawn)
    elseif char == 'B'
        return Piece(White, Bishop)
    elseif char == 'N'
        return Piece(White, Knight)
    elseif char == 'R'
        return Piece(White, Rook)
    elseif char == 'Q'
        return Piece(White, Queen)
    elseif char == 'K'
        return Piece(White, King)
    elseif char == 'p'
        return Piece(Black, Pawn)
    elseif char == 'b'
        return Piece(Black, Bishop)
    elseif char == 'n'
        return Piece(Black, Knight)
    elseif char == 'r'
        return Piece(Black, Rook)
    elseif char == 'q'
        return Piece(Black, Queen)
    elseif char == 'k'
        return Piece(Black, King)
    else
        error("Invalid character for piece: $char")
    end
end

# return a FEN character from the corresponding piece.
function to_letter(piece::Piece)::String
    if piece.type == Pawn
        piece_string = "P"
    elseif piece.type == Knight
        piece_string = "N"
    elseif piece.type == Bishop
        piece_string = "B"
    elseif piece.type == Rook
        piece_string = "R"
    elseif piece.type == Queen
        piece_string = "Q"
    elseif piece.type == King
        piece_string = "K"
    end

    if piece.color == Black
        return lowercase(piece_string)
    else 
        return piece_string
    end
end

# returns if two pieces are the same (White Pawn, Black Knight, etc.)
function ==(piece1::Piece, piece2::Piece)
    return piece1.color == piece2.color && piece1.type == piece2.type
end
