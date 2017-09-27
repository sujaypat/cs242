import junit.framework.TestCase;

public class TallBoyeTest extends TestCase {

    /**
     * Test movement and capture
     * @throws Exception
     */
    public void testMove() throws Exception {
        Board testGame = new Board(8, 8);
        assertTrue(testGame.move(6, 0, 4, 0)); // valid move
        assertFalse(testGame.move(4, 0, 3, 0)); // invalid move
        assertTrue(testGame.move(4, 0, 2, 0)); // valid move
        assertTrue(testGame.move(2, 0, 0, 2)); // capturing move
    }

}
