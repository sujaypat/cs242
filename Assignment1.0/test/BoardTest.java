import junit.framework.TestCase;

public class BoardTest extends TestCase {

    public void testMove() throws Exception {
        Board testGame = new Board();
        assertTrue(testGame.move(6, 0, 4, 0)); //pawn up 2 spaces on first move (valid)
        assertFalse(testGame.move(0, 2, 1, 2)); //bishop straight down (invalid)
        assertFalse(testGame.move(4, 4, 3, 2)); // no piece at this position
        assertFalse(testGame.move(7, 7, 7, 8)); // valid move, but out of bounds
        assertFalse(testGame.move(7, 7, 6, 7)); // valid move, but collision
    }

    public void testInBounds() throws Exception {
        Board testGame = new Board();
        assertTrue(testGame.inBounds(0, 0)); // in bounds
        assertFalse(testGame.inBounds(4, 9)); // out of bounds
    }

}
