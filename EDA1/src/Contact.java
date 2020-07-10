import EDA1.AVL.*;

public class Contact implements Comparable<Contact> {
    String name;
    AVL<String> phoneNumbers;

    Contact(String name, String phoneNumber) {
        this.name = name;
        phoneNumbers = new ArvVL<>(phoneNumber);
    }

    Contact(String name) {
        this.name = name;
        phoneNumbers = new ArvVL<>();
    }

    public String editName(String novo) {
        return name = novo;
    }

    public void addNumber(String number) {
        phoneNumbers.insert(number);
    }

    public void getNumbers() {
        phoneNumbers.printInOrder();
    }

    public int compareTo(Contact o) {
        return name.compareTo(o.name);
    }

    public boolean contains(String number) {
        return phoneNumbers.contains(number);
    }

    public void removeNumber(String number) {
        phoneNumbers.remove(number);
    }

    public void editNumber(String number, String newNumber) {
        removeNumber(number);
        addNumber(newNumber);
    }
}
        