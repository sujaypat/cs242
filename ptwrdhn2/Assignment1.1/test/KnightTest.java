import junit.framework.TestCase;

public class KnightTest extends TestCase {

    /**
     * Test movement and capture
     * @throws Exception
     */
    public void testMove() throws Exception {
        Board testGame = new Board(8, 8);
        assertTrue(testGame.move(7, 1, 5, 0)); // valid move (up 2 left 1)
        assertFalse(testGame.move(7, 6, 6, 4)); // valid move, but collision
    }

}
