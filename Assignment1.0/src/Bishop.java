public class Bishop extends ChessPiece {

    public Bishop(int color) {
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
        if (Math.abs(destRow - currRow) != Math.abs(destCol - currCol)) {
            return false; // Not a slope of 1
        }
        if (destCol > currCol && destRow > currRow) { // down and right
            for (int row = currRow + 1, col = currCol + 1; row < destRow && col < destCol;
                row++, col++) {
                if (row == destRow && col == destCol) {
                    break;
                }
                if (board[row][col] != null) {
                    return false;
                }
            }
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        if (destCol > currCol && destRow < currRow) { // up and right
            for (int row = currRow - 1, col = currCol + 1; row > destRow && col < destCol;
                row--, col++) {
                if (row == destRow && col == destCol) {
                    break;
                }
                if (board[row][col] != null) {
                    return false;
                }
            }
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        if (destCol < currCol && destRow > currRow) { // down and left
            for (int row = currRow + 1, col = currCol - 1; row < destRow && col > destCol;
                row++, col--) {
                if (row == destRow && col == destCol) {
                    break;
                }
                if (board[row][col] != null) {
                    return false;
                }
            }
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        if (destCol < currCol && destRow < currRow) { // up and left
            for (int row = currRow - 1, col = currCol - 1; row > destRow && col > destCol;
                row--, col--) {
                if (row == destRow && col == destCol) {
                    break;
                }
                if (board[row][col] != null) {
                    return false;
                }
            }
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        return false;
    }
}
