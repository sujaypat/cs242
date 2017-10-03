public class Queen extends ChessPiece {

    public Queen(int color) {
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
        // Horizontal movement
        if (currRow == destRow) {
            if (Math.abs(currCol - destCol) == 1) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
            int start = Math.min(currCol, destCol) + 1;
            int end = Math.max(currCol, destCol) - 1;
            for (int column = start; column < end; column++) {
                if (board[currRow][column] != null) {
                    return false;
                }
            }
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        // Vertical movement
        if (currCol == destCol) {
            if (Math.abs(currRow - destRow) == 1) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
            int start = Math.min(currRow, destRow) + 1;
            int end = Math.max(currRow, destRow) - 1;
            for (int row = start; row < end; row++) {
                if (board[row][currCol] != null) {
                    return false;
                }
            }
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        // Diagonal movement
        if (Math.abs(destRow - currRow) == Math.abs(destCol - currCol)) {
            if (destCol > currCol && destRow > currRow) { // down and right
                for (int row = currRow + 1, col = currCol + 1; row < destRow && col < destCol;
                    row++, col++) {
                    if (board[row][col] != null) {
                        return false;
                    }
                }
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
            if (destCol > currCol && destRow < currRow) { // up and right
                for (int row = currRow - 1, col = currCol + 1; row > destRow && col < destCol;
                    row--, col++) {
                    if (board[row][col] != null) {
                        return false;
                    }
                }
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
            if (destCol < currCol && destRow > currRow) { // down and left
                for (int row = currRow + 1, col = currCol - 1; row < destRow && col > destCol;
                    row++, col--) {
                    if (board[row][col] != null) {
                        return false;
                    }
                }
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
            if (destCol < currCol && destRow < currRow) { // up and left
                for (int row = currRow - 1, col = currCol - 1; row > destRow && col > destCol;
                    row--, col--) {
                    if (board[row][col] != null) {
                        return false;
                    }
                }
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
        }
        return false;
    }
}
