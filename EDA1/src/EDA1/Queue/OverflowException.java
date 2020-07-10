package EDA1.Queue;

public class OverflowException extends Exception {
    OverflowException(){
        super("Queue is full!");
    }
}
