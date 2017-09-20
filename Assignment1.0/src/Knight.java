public class Knight extends ChessPiece {

    public Knight(int color) {
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

        if ((destRow == currRow - 2 && destCol == currCol - 1) ||
            (destRow == currRow - 1 && destCol == currCol - 2) ||
            (destRow == currRow - 2 && destCol == currCol + 1) ||
            (destRow == currRow - 1 && destCol == currCol + 2) ||
            (destRow == currRow + 2 && destCol == currCol - 1) ||
            (destRow == currRow + 1 && destCol == currCol - 2) ||
            (destRow == currRow + 2 && destCol == currCol + 1) ||
            (destRow == currRow + 1 && destCol == currCol + 2)) {
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        return false;
    }

}
