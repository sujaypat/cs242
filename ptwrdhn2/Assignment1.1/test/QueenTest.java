import junit.framework.TestCase;

public class QueenTest extends TestCase {

    public void testMove() throws Exception {
        Board testGame = new Board(8, 8);
        assertFalse(testGame.move(7,3,7,4)); // valid move, but collision
        testGame.move(6,3,4,3); // move pawn out of the way
        testGame.move(7,3,5,3); // valid move
        testGame.move(5,3,4,2); // valid move
        assertTrue(testGame.move(4,2,1,2)); // capturing move
    }

}
