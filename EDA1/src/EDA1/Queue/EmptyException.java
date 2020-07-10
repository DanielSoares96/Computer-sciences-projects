package EDA1.Queue;

public class EmptyException extends Exception {
    EmptyException(){
        super("Queue is empty!");
    }
}
