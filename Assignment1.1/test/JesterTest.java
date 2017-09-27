import junit.framework.TestCase;

public class JesterTest extends TestCase {

    public void testMove() throws Exception {
        Board testGame = new Board(8,8);
        assertFalse(testGame.move(6,7,5,7)); // invalid move
        assertTrue(testGame.move(6,7,5,6)); // valid move
        testGame.move(5,6,4,5); // valid move
        testGame.move(4,5,3,4); // valid move
        assertTrue(testGame.move(3,4,1,4)); // valid capture
    }

}
