import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.util.Stack;
import javax.swing.*;

public class Controller {

    public static Stack<String> moves;
    public int whoseTurn = Constants.WHITE;
    public Board gameBoard;
    public GUI gameGUI;
    ImageIcon holder = new ImageIcon(
        new BufferedImage(64, 64, BufferedImage.TYPE_INT_ARGB));

    public Controller() {

        moves = new Stack<>();

        JFrame frame = new JFrame();
        String dims = (String)JOptionPane.showInputDialog(
            frame,
            "Game board size (format: rows,cols) where rows >= 8 and cols >= 8:\n",
            "Game setup",
            JOptionPane.PLAIN_MESSAGE,
            null,
            null,
            null);


        String[] dimensions = dims.split(",");
        int rows = 8;
        int cols = 8;
        try {
            rows = Integer.parseInt(dimensions[0]);
            cols = Integer.parseInt(dimensions[1]);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Defaulting to 8x8");
        }
        if(rows < 1 || cols < 1) {
            JOptionPane.showMessageDialog(null, "Defaulting to 8x8");
            rows = 8;
            cols = 8;
        }
        else if (rows < 8 || cols < 8) {
            JOptionPane.showMessageDialog(null, "Fine.");
        }
        String p1 = (String)JOptionPane.showInputDialog(
            frame,
            "Player 1 name:\n",
            "Game setup",
            JOptionPane.PLAIN_MESSAGE,
            null,
            null,
            null);
        String p2 = (String)JOptionPane.showInputDialog(
            frame,
            "Player 2 name:\n",
            "Game setup",
            JOptionPane.PLAIN_MESSAGE,
            null,
            null,
            null);
        String custom = (String)JOptionPane.showInputDialog(
            frame,
            "Custom pieces? (y/n):\n",
            "Game setup",
            JOptionPane.PLAIN_MESSAGE,
            null,
            null,
            null);



        frame.setVisible(true);
        boolean customPieces = custom.equals("y");

        gameGUI = new GUI(rows, cols, customPieces, p1, p2);
        gameGUI.custom = customPieces;

        gameBoard = new Board(rows, cols, customPieces);

        JFrame f = new JFrame("CS242 Chess");
        f.add(gameGUI.getGui());
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack();
        f.setMinimumSize(f.getSize());
        f.setVisible(true);
    }



    public void run(){

        boolean done = false;
        int count = 0;
        int currCount = 0;

        while(!done){
            while (moves.size() % 2 != 0) {}
            if(gameBoard.inStalemate(whoseTurn)){
                System.out.println("Stalemate detected");
                break;
            }

            System.out.println("move number: " + count++);
            while(moves.size() < 2) {}
//            while (moves.size() % 2 != 0) {}

            String destination = moves.pop();
            String origin = moves.peek();
            moves.push(destination);

            String[] destSquares = destination.split(":");
            String[] origSquares = origin.split(":");
            int destRow = Integer.parseInt(destSquares[1]);
            int destCol = Integer.parseInt(destSquares[0]);
            int origRow = Integer.parseInt(origSquares[1]);
            int origCol = Integer.parseInt(origSquares[0]);



            if(gameBoard.move(origRow, origCol, destRow, destCol)){
                gameGUI.boardSquares[destCol][destRow].setIcon(gameGUI.boardSquares[origCol][origRow].getIcon());
                gameGUI.boardSquares[origCol][origRow].setIcon(holder);
                gameGUI.boardSquares[destCol][destRow].repaint();
                gameGUI.boardSquares[origCol][origRow].repaint();
                System.out.println("Valid move");
                whoseTurn = 1 - whoseTurn; // alternates between 1 and 0
                currCount++;
                continue;
            }
            break;

        }
    }


}

class SquareListener implements ActionListener {

    /**
     * Invoked when an action occurs.
     */
    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println(((JButton) e.getSource()).getName());
        Controller.moves.push(((JButton) e.getSource()).getName());
    }
}
