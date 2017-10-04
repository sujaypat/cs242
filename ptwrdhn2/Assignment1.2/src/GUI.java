import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.*;
import javax.imageio.*;
import javax.swing.*;
import javax.swing.border.*;

public class GUI {

    public static final int QUEEN = 0, KING = 1,
        ROOK = 2, KNIGHT = 3, BISHOP = 4, PAWN = 5, JESTER = 6, TALLBOYE = 7;
    public static final int[] CUSTOM_PAWNS = {
        TALLBOYE, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, JESTER
    };
    public static final int[] STARTING_ROW = {
        ROOK, KNIGHT, BISHOP, KING, QUEEN, BISHOP, KNIGHT, ROOK
    };
    private final JPanel gui = new JPanel(new BorderLayout(5, 5));
    public JButton[][] boardSquares;
    private Image[][] pieceImages = new Image[2][8];
    private JPanel chessBoard;

    public String p1Name, p2Name;
    public float[] scores = new float[2];
    public boolean custom = false;

    public GUI(int rows, int cols, boolean custom, String player1Name, String player2Name) {
        boardSquares = new JButton[rows][cols];
        this.p1Name = player1Name;
        this.p2Name = player2Name;
        initializeGui(rows, cols, custom);
    }

    /**
     * Method to set up initial state of GUI
     */
    public final void initializeGui(int rows, int cols, boolean custom) {
        createImages();

        chessBoard = new JPanel(new GridLayout(rows, cols));
        chessBoard.setPreferredSize(new Dimension(600, 600));

        JToolBar toolBar = new JToolBar();
        JButton temp = null;

        temp = new JButton("New regular game");
        temp.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setupNewGame(false);
            }
        });
        toolBar.add(temp);

        temp = new JButton("New custom game");
        temp.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setupNewGame(true);
            }
        });
        toolBar.add(temp);

        temp = new JButton("Forfeit");
        temp.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
//                // Give point to other player
                scores[1 - Controller.whoseTurn] += 1;
                setupNewGame(custom);

            }
        });
        toolBar.add(temp);

        temp = new JButton("Restart?");
        temp.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                // Check that it's clicked twice and then restart with 0.5 points to each
                scores[0] += 0.5;
                scores[1] += 0.5;
                setupNewGame(custom);
            }
        });
        toolBar.add(temp);

        toolBar.addSeparator();

        JLabel player1 = new JLabel(p1Name + ": " + scores[0]);
        toolBar.add(player1);

        toolBar.addSeparator();

        JLabel player2 = new JLabel(p2Name + ": " + scores[1]);
        toolBar.add(player2);

        toolBar.setFloatable(false);
        toolBar.setVisible(true);
        gui.add(toolBar, BorderLayout.NORTH);

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
                square.setName(i + ":" + j);
                square.addActionListener(new SquareListener());
                boardSquares[i][j] = square;
            }
        }
        for (int col = 0; col < cols; col++) {
            for (int row = 0; row < rows; row++) {
                chessBoard.add(boardSquares[row][col]);
            }
        }
        setupNewGame(custom);
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
            pieceImages[0][6] = ImageIO.read(new File("images/black_jester.png")); // black jester
            pieceImages[0][7] = ImageIO.read(new File("images/black_tallboye.png")); // black tallboye
            pieceImages[1][0] = ImageIO.read(new File("images/white_king.png")); //white king
            pieceImages[1][1] = ImageIO.read(new File("images/white_queen.png")); //white queen
            pieceImages[1][2] = ImageIO.read(new File("images/white_rook.png")); //white rook
            pieceImages[1][3] = ImageIO.read(new File("images/white_knight.png")); //white knight
            pieceImages[1][4] = ImageIO.read(new File("images/white_bishop.png")); //white bishop
            pieceImages[1][5] = ImageIO.read(new File("images/white_pawn.png")); //white pawn
            pieceImages[1][6] = ImageIO.read(new File("images/white_jester.png")); // white jester
            pieceImages[1][7] = ImageIO.read(new File("images/white_tallboye.png")); // white tallboye
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Initializes the icons of the initial chess board piece places
     */
    private final void setupNewGame(boolean customPieces) {
        for (int i = 0; i < STARTING_ROW.length; i++) {
            boardSquares[i][0].setIcon(new ImageIcon(
                pieceImages[Constants.BLACK][STARTING_ROW[i]]));
            boardSquares[i][boardSquares.length - 1].setIcon(new ImageIcon(
                pieceImages[Constants.WHITE][STARTING_ROW[i]]));
        }
        // instantiate pawns and jester/tallboye if we're using custom pieces
        for (int i = 0; i < STARTING_ROW.length; i++) {
            if(customPieces){
                boardSquares[i][1].setIcon(new ImageIcon(
                    pieceImages[Constants.BLACK][CUSTOM_PAWNS[i]]));
                boardSquares[i][boardSquares.length - 2].setIcon(new ImageIcon(
                    pieceImages[Constants.WHITE][CUSTOM_PAWNS[i]]));
            }
            else {
                boardSquares[i][1].setIcon(new ImageIcon(
                    pieceImages[Constants.BLACK][PAWN]));
                boardSquares[i][boardSquares.length - 2].setIcon(new ImageIcon(
                    pieceImages[Constants.WHITE][PAWN]));
            }
        }
    }
}
