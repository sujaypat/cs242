import java.util.Arrays;

public class Board {

    private ChessPiece[][] board = null;
    private int whoseTurn = Constants.WHITE;


    public Board(int rows, int cols) {

        board = new ChessPiece[rows][cols];
        initBoard();
    }

    public Board() {

        board = new ChessPiece[8][8];
        initBoard();
    }

    public ChessPiece[][] getBoard() {

        return this.board;
    }

    private void initBoard() {
        for (int i = 0; i < board.length; i++) {
            Arrays.fill(board[i], null);
        }
        Arrays.fill(board[1], new Pawn(Constants.BLACK));
        Arrays.fill(board[board.length - 2], new Pawn(Constants.WHITE));

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

    public boolean move(int originRow, int originCol, int destRow, int destCol) {
        if (!inBounds(destRow, destCol)) {
            System.out.println("Destination is out of bounds!");
            return false;
        }
        if (board[originRow][originCol] == null) {
            System.out.println("There is no piece at the given starting position!");
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

    public boolean inStalemate(int color) {
        boolean allStale = false;
        for (int row = 0; row < board.length; row++) {
            for (int col = 0; col < board[row].length; col++) {
                if (board[row][col] != null && board[row][col].color == color) {
                    allStale |= tryToGoEverywhere(row, col, color);
                }
            }
        }
        return allStale;
    }

    private boolean tryToGoEverywhere(int currRow, int currCol, int color) {
        boolean canGoAnywhere = false;
        for (int row = 0; row < board.length; row++) {
            for (int col = 0; col < board[row].length; col++) {
                if (board[currRow][currCol] != null && board[currRow][currCol].color == color) {
                    canGoAnywhere |= this.move(currRow, currCol, row, col);
                }
            }
        }
        return canGoAnywhere;
    }

}
