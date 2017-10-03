import junit.framework.TestCase;

public class RookTest extends TestCase {

    /**
     * Test movement and capture
     * @throws Exception
     */
    public void testMove() throws Exception {
        Board testGame = new Board(8, 8,false);
//        assertTrue(testGame.move(7,0,5,0)); // valid move (up 2)
        assertFalse(testGame.move(7, 0, 4, 0)); // valid move, but collision
    }

}
