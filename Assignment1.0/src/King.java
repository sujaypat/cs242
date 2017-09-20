public class King extends ChessPiece {

    public King(int color) {
        this.color = color;
    }

    /**
     * @param currRow Current row position of piece
     * @param currCol Current column position of piece
     * @param destRow Destination row
     * @param destCol Destination column
     * @param board copy of current board
     * @return Whether the move can be made
     */
    @Override
    public boolean move(int currRow, int currCol, int destRow, int destCol, ChessPiece[][] board) {
        if (Math.abs(currRow - destRow) <= 1 && Math.abs(currCol - destCol) <= 1) {
            if (isInCheck(destRow, destCol, board, this.color)) {
                System.out.println("Illegal move: king would be in check");
                return false;
            }
            if (this.color == Constants.WHITE) {
                return !checkIfFriendlyInDest(destRow, destCol, board)
                    || board[destRow][destCol] == null;
            }
            if (this.color == Constants.BLACK) {
                return !checkIfFriendlyInDest(destRow, destCol, board)
                    || board[destRow][destCol] == null;
            }
        }
        return false;
    }

    /**
     * @param currRow row position of king
     * @param currCol col position of king
     * @param board copy of board
     * @param color color of kind we're testing
     * @return True if the given position can be attacked by any of the opponent's pieces
     */
    public boolean isInCheck(int currRow, int currCol, ChessPiece[][] board, int color) {
        for (int row = 0; row < board.length; row++) {
            for (int col = 0; col < board[row].length; col++) {
                if (board[row][col] != null &&
                    board[row][col].color != color &&
                    board[row][col].move(row, col, currRow, currCol, board)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * @param currRow row position of king
     * @param currCol col position of king
     * @param board copy of board
     * @param color color of kind we're testing
     * @return True if the king cannot move anywhere safe
     */
    // This function will run at each iteration of the main game loop.
    public boolean isInCheckMate(int currRow, int currCol, ChessPiece[][] board, int color) {
        boolean mate = false;
        for (int row = -1; row < 1; row++) {
            for (int col = -1; col < 1; col++) {
                mate |= isInCheck(currRow + row, currCol + col, board, color);
            }
        }
        return mate;
    }
}
