import junit.framework.TestCase;

public class BishopTest extends TestCase {

    /**
     * Test movement and capture
     * @throws Exception
     */
    public void testMove() throws Exception {
        Board testGame = new Board(8,8);
        testGame.move(6,3,4,3); // move pawn out of the way
        assertTrue(testGame.move(7,2,4,5)); // valid move
        assertFalse(testGame.move(4,5,3,5)); // invalid move
        assertTrue(testGame.move(4,5,1,2)); // valid capture
    }

}
