import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import javax.imageio.*;
import javax.swing.*;
import javax.swing.border.*;

public class GUI {

    public static final int QUEEN = 0, KING = 1,
        ROOK = 2, KNIGHT = 3, BISHOP = 4, PAWN = 5;
    public static final int[] STARTING_ROW = {
        ROOK, KNIGHT, BISHOP, KING, QUEEN, BISHOP, KNIGHT, ROOK
    };
    private final JPanel gui = new JPanel(new BorderLayout(3, 3));
    private JButton[][] boardSquares = new JButton[8][8];
    private Image[][] pieceImages = new Image[2][6];
    private JPanel chessBoard;

    public GUI() {
        initializeGui();
    }

    public static void main(String[] args) {

        GUI cg = new GUI();

        JFrame f = new JFrame("CS242 Chess");
        f.add(cg.getGui());
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack();
        f.setMinimumSize(f.getSize());
        f.setVisible(true);
    }

    /**
     * Method to set up initial state of GUI
     */
    public final void initializeGui() {
        createImages();

        chessBoard = new JPanel(new GridLayout(0, 8));
        chessBoard.setPreferredSize(new Dimension(500, 500));

        JPanel outerPanel = new JPanel(new GridBagLayout());
        outerPanel.add(chessBoard);
        gui.add(outerPanel);

        for (int i = 0; i < boardSquares.length; i++) {
            for (int j = 0; j < boardSquares[i].length; j++) {
                JButton square = new JButton();
                square.setBorder(new EmptyBorder(0,0,0,0));

                // 64x64 placeholder
                ImageIcon holder = new ImageIcon(
                    new BufferedImage(64, 64, BufferedImage.TYPE_INT_ARGB));
                square.setIcon(holder);

                if ((j % 2 == 1 && i % 2 == 0) || (j % 2 == 0 && i % 2 == 1)) {
                    square.setBackground(Color.GRAY);
                } else {
                    square.setBackground(Color.WHITE);
                }
                square.setOpaque(true);
                boardSquares[i][j] = square;
            }
        }
        for (int col = 0; col < 8; col++) {
            for (int row = 0; row < 8; row++) {
                chessBoard.add(boardSquares[row][col]);
            }
        }
        setupNewGame();
    }

    public JComponent getGui() {
        return gui;
    }

    /**
     * Loads image resources and fills the image array with piece icons
     */
    private final void createImages() {
        try {
            pieceImages[0][0] = ImageIO.read(new File("images/black_king.png")); //black king
            pieceImages[0][1] = ImageIO.read(new File("images/black_queen.png")); //black queen
            pieceImages[0][2] = ImageIO.read(new File("images/black_rook.png")); //black rook
            pieceImages[0][3] = ImageIO.read(new File("images/black_knight.png")); //black knight
            pieceImages[0][4] = ImageIO.read(new File("images/black_bishop.png")); //black bishop
            pieceImages[0][5] = ImageIO.read(new File("images/black_pawn.png")); //black pawn
            pieceImages[1][0] = ImageIO.read(new File("images/white_king.png")); //white king
            pieceImages[1][1] = ImageIO.read(new File("images/white_queen.png")); //white queen
            pieceImages[1][2] = ImageIO.read(new File("images/white_rook.png")); //white rook
            pieceImages[1][3] = ImageIO.read(new File("images/white_knight.png")); //white knight
            pieceImages[1][4] = ImageIO.read(new File("images/white_bishop.png")); //white bishop
            pieceImages[1][5] = ImageIO.read(new File("images/white_pawn.png")); //white pawn
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Initializes the icons of the initial chess board piece places
     */
    private final void setupNewGame() {
        for (int i = 0; i < STARTING_ROW.length; i++) {
            boardSquares[i][0].setIcon(new ImageIcon(
                pieceImages[Constants.BLACK][STARTING_ROW[i]]));
            boardSquares[i][7].setIcon(new ImageIcon(
                pieceImages[Constants.WHITE][STARTING_ROW[i]]));
        }
        for (int i = 0; i < STARTING_ROW.length; i++) {
            boardSquares[i][1].setIcon(new ImageIcon(
                pieceImages[Constants.BLACK][PAWN]));
            boardSquares[i][6].setIcon(new ImageIcon(
                pieceImages[Constants.WHITE][PAWN]));
        }
    }
}
