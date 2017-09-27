/**
 * Class for Pawn pieces
 */
public class Pawn extends ChessPiece {

    boolean firstMove; // Used to decide if a 2 position vertical move is allowed

    /**
     * @param color Takes the color of the pawn
     */
    public Pawn(int color) {
        firstMove = true;
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
        if (firstMove && currCol == destCol) { // No attacking can happen here
            if (color == Constants.WHITE && destRow >= currRow - 2) {
                firstMove = false;
                return !checkIfFriendlyInDest(destRow, destCol, board) &&
                    !checkIfFriendlyInDest(destRow + 1, destCol, board);
            }
            if (color == Constants.BLACK && destRow <= currRow + 2) {
                firstMove = false;
                return !checkIfFriendlyInDest(destRow, destCol, board) &&
                    !checkIfFriendlyInDest(destRow - 1, destCol, board);
            }
        }
        // Regular movement (i.e. not attacking)
        if (destCol == currCol) {
            if (color == Constants.WHITE && destRow == currRow - 1) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
            if (color == Constants.BLACK && destRow == currRow + 1) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
        }
        //Attacking
        if (color == Constants.WHITE) {
            if (Math.abs(destCol - currCol) == 1 && (destRow - currRow) == -1) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
        }
        if (color == Constants.BLACK) {
            if (Math.abs(destCol - currCol) == 1 && (destRow - currRow == 1)) {
                return !checkIfFriendlyInDest(destRow, destCol, board);
            }
        }
        return false;
    }
}
