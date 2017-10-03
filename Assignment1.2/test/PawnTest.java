import junit.framework.TestCase;

public class PawnTest extends TestCase {

    public void testMove() throws Exception {
        Board testGame = new Board(8,8,false);
        assertTrue(testGame.move(6,1,4,1)); // move 2 on first move
        assertTrue(testGame.move(6,3,5,3)); // move 1 on first move
        assertFalse(testGame.move(6,2,5,1)); // try to attack an empty square

        assertFalse(testGame.move(4,1,2,1)); // move 2 on non first move
        testGame.move(4,1,3,1);
        testGame.move(3,1,2,1);
        assertTrue(testGame.move(2,1,1,2)); // attack
    }

}
