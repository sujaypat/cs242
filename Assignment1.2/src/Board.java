import java.util.Arrays;

public class Board {

    private ChessPiece[][] board = null;
    public int whoseTurn = Constants.WHITE;
    public boolean actuallyPlaying = false;

    public Board(int rows, int cols, boolean custom) {

        board = new ChessPiece[rows][cols];
        initBoard(custom);

    }

    public ChessPiece[][] getBoard() {

        return this.board;
    }

    /**
     * Initializes board with boolean flag for custom pieces
     */
    private void initBoard(boolean custom) {
        for (int i = 0; i < board.length; i++) {
            Arrays.fill(board[i], null);
        }
        Arrays.fill(board[1], new Pawn(Constants.BLACK));
        Arrays.fill(board[board.length - 2], new Pawn(Constants.WHITE));

        if (custom) {
            board[1][0] = new TallBoye(Constants.BLACK);
            board[board.length - 2][0] = new TallBoye(Constants.WHITE);

            board[1][board.length - 1] = new Jester(Constants.BLACK);
            board[board.length - 2][board[0].length - 1] = new Jester(Constants.WHITE);
        }

        board[0][0] = new Rook(Constants.BLACK);
        board[0][board[0].length - 1] = new Rook(Constants.BLACK);
        board[board.length - 1][0] = new Rook(Constants.WHITE);
        board[board.length - 1][board[0].length - 1] = new Rook(Constants.WHITE);

        board[0][1] = new Knight(Constants.BLACK);
        board[0][board[0].length - 2] = new Knight(Constants.BLACK);
        board[board.length - 1][1] = new Knight(Constants.WHITE);
        board[board.length - 1][board[0].length - 2] = new Knight(Constants.WHITE);

        board[0][2] = new Bishop(Constants.BLACK);
        board[0][board[0].length - 3] = new Bishop(Constants.BLACK);
        board[board.length - 1][2] = new Bishop(Constants.WHITE);
        board[board.length - 1][board[0].length - 3] = new Bishop(Constants.WHITE);

        board[0][3] = new Queen(Constants.BLACK);
        board[0][board[0].length - 4] = new King(Constants.BLACK);

        board[board.length - 1][3] = new Queen(Constants.WHITE);
        board[board.length - 1][board[0].length - 4] = new King(Constants.WHITE);

    }

    public boolean isEmpty(int row, int col) {

        return this.board[row][col] == null;
    }

    /**
     * Abstracts the actual movement to the specific piece, but does checks for boundaries and ownership
     * @param originRow piece starting row
     * @param originCol piece starting column
     * @param destRow piece ending row
     * @param destCol piece ending column
     * @return true if move was completed
     */
    public boolean move(int originRow, int originCol, int destRow, int destCol) {
        if (!inBounds(destRow, destCol)) {
            System.out.println("Destination is out of bounds!");
            return false;
        }
        if (board[originRow][originCol] == null) {
            System.out.println("There is no piece at the given starting position!");
            return false;
        }
        if (actuallyPlaying && board[originRow][originCol].color != whoseTurn) {
            System.out.println("This is not your piece!");
            return false;
        }
        if (board[originRow][originCol].move(originRow, originCol, destRow, destCol, board)) {
            if (!isEmpty(destRow, destCol)) {
                System.out.println(
                    board[originRow][originCol].getClass().getName() + " previously at row "
                        + originRow +
                        " col " + originCol + " captured " + board[destRow][destCol].getClass()
                        .getName() +
                        " at row " + destRow + " col " + destCol);
            } else {
                System.out.println(
                    board[originRow][originCol].getClass().getName() + " previously at row "
                        + originRow +
                        " col " + originCol + " is now at row " + destRow + " col " + destCol);
            }
            board[destRow][destCol] = board[originRow][originCol];
            board[originRow][originCol] = null;

            return true;
        } else {
            System.out.println("This is not a valid move!");
        }
        return false;
    }

    public boolean inBounds(int destRow, int destCol) {
        if (destRow < this.board.length && destRow >= 0 && destCol < this.board[destRow].length
            && destCol >= 0) {
            return true;
        }
        return false;
    }

    /**
     * Checks for a specific color in stalemate
     * @param color currently playing color
     * @return
     */
    public boolean inStalemate(int color) {
        for (int row = 0; row < board.length; row++) {
            for (int col = 0; col < board[row].length; col++) {
                if (board[row][col] != null && board[row][col].color == color) {
                    if(tryToGoEverywhere(row, col, color)){
                        return false;
                    }
                }
            }
        }
        return true;
    }

    private boolean tryToGoEverywhere(int currRow, int currCol, int color) {
        for (int row = 0; row < board.length; row++) {
            for (int col = 0; col < board[row].length; col++) {
                if (board[currRow][currCol] != null && board[currRow][currCol].color == color) {
                    if(this.move(currRow, currCol, row, col)){
                        board[currRow][currCol] = board[row][col];
                        board[row][col] = null;
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
