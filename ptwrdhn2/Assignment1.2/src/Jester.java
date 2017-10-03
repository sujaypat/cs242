/**
 * Either moves a single square diagonally or attacks 2 spaces straight ahead
 */
public class Jester extends ChessPiece {

    public Jester(int color) {
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
        // check if attacking
        if (Math.abs(currRow - destRow) == 2){
            if (this.color == Constants.BLACK){
                return !checkIfFriendlyInDest(destRow + 1, destCol, board) &&
                    board[destRow][destCol] != null &&
                    board[destRow][destCol].color != this.color;
            }
            if (this.color == Constants.WHITE){
                return !checkIfFriendlyInDest(destRow - 1, destCol, board) &&
                    board[destRow][destCol] != null &&
                    board[destRow][destCol].color != this.color;
            }
        }
        // if not enforce diagonal move
        if (Math.abs(currRow - destRow) == 1 && Math.abs(currCol - destCol) == 1) {
            return !checkIfFriendlyInDest(destRow, destCol, board);
        }
        return false;
    }
}
