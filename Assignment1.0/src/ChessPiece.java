public abstract class ChessPiece {

    public int color;

    /**
     * @param destRow destination row
     * @param destCol destination column
     * @param board copy of the board
     * @return True iff there is a friendly in the destination space
     */
    public boolean checkIfFriendlyInDest(int destRow, int destCol, ChessPiece[][] board) {
        return board[destRow][destCol] != null && board[destRow][destCol].color == this.color;
    }

    /**
     * @param currRow Current row position of piece
     * @param currCol Current column position of piece
     * @param destRow Destination row
     * @param destCol Destination column
     * @param board copy of current board
     * @return Whether the move can be made
     */
    public abstract boolean move(int currRow, int currCol, int destRow, int destCol,
        ChessPiece[][] board);

}
