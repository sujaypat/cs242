/**
 * Leaps 2 squares in any direction because he's a T A L L B O Y E
 */
public class TallBoye extends ChessPiece {

    public TallBoye(int color) {
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
            if (Math.abs(currCol - destCol) == 2) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
        }
        // Vertical movement
        if (currCol == destCol) {
            if (Math.abs(currRow - destRow) == 2) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
        }
        // Diagonal movement
        if (Math.abs(destRow - currRow) == Math.abs(destCol - currCol) &&
            Math.abs(destCol - currCol) == 2 &&
            Math.abs(destRow - currRow) == 2) {
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        return false;
    }
}
