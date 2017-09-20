import junit.framework.TestCase;

public class KingTest extends TestCase {


    public void testMove() throws Exception {
        Board testGame = new Board();
        assertTrue(testGame.getBoard()[7][4] instanceof King);
        testGame.move(6,4,4,4); // move pawn
        assertFalse(testGame.move(7,4,5,4)); // invalid move
        assertFalse(testGame.move(7,4,7,5)); // collision
        assertTrue(testGame.move(7,4,6,4)); // valid move
    }

    public void testIsInCheck() throws Exception {
        Board testGame = new Board();
        assertTrue(testGame.getBoard()[7][4] instanceof King);

        testGame.move(6,5,4,5); // move pawn
        testGame.move(4,5,3,5); // move pawn
        testGame.move(3,5,2,5); // move pawn
        testGame.move(2,5,1,4); // move pawn to capture

        testGame.move(7,4,6,5); // move king
        testGame.move(6,5,5,4); // move king
        testGame.move(1,5,2,5); // move opponent pawn
        testGame.move(5,4,4,4); // move king
        assertFalse(testGame.move(4,4,3,4)); // move king into check
    }

    public void testIsInCheckMate() throws Exception {
    }

}
