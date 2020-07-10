package EDA1.LinkedList;

public class Test {
    public static void main(String[] args){
        DoubleLinkedList<Integer> dll = new DoubleLinkedList<>();
        dll.add(1);
        dll.add(2);
        dll.add(3);
        dll.add(4);
        dll.add(5);
        dll.removeIndex(2);

        System.out.println(dll.toString());
    }
}
