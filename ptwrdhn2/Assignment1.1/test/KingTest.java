import junit.framework.TestCase;

public class KingTest extends TestCase {


    /**
     * Test movement and capture
     * @throws Exception
     */
    public void testMove() throws Exception {
        Board testGame = new Board(8, 8);
        assertTrue(testGame.getBoard()[7][4] instanceof King);
        testGame.move(6, 4, 4, 4); // move pawn
        assertFalse(testGame.move(7, 4, 5, 4)); // invalid move
        assertFalse(testGame.move(7, 4, 7, 5)); // collision
        assertTrue(testGame.move(7, 4, 6, 4)); // valid move
    }

    /**
     * Test king in check
     * @throws Exception
     */
    public void testIsInCheck() throws Exception {
        Board testGame = new Board(8, 8);
        assertTrue(testGame.getBoard()[7][4] instanceof King);

        testGame.move(6, 5, 4, 5); // move pawn
        testGame.move(4, 5, 3, 5); // move pawn
        testGame.move(3, 5, 2, 5); // move pawn
        testGame.move(2, 5, 1, 4); // move pawn to capture

        testGame.move(7, 4, 6, 5); // move king
        testGame.move(6, 5, 5, 4); // move king
        testGame.move(5, 4, 4, 4); // move king
        testGame.move(4, 4, 3, 4); // move king
        assertFalse(testGame.move(3, 4, 2, 4)); // move king into check
    }

    /**
     * Test king in checkmate
     * @throws Exception
     */
    public void testIsInCheckMate() throws Exception {
        // use a knight probably
        Board testGame = new Board(8, 8);
        testGame.move(7, 1, 5, 2);
        testGame.move(5, 2, 3, 3);
        testGame.move(3, 3, 2, 5); // should be in checkmate
    }

}
