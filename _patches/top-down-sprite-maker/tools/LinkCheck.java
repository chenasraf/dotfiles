/** Initializes each named class, which makes the JVM verify its bytecode first. */
public class LinkCheck {
    public static void main(String[] names) throws Exception {
        for (String name : names)
            Class.forName(name, true, LinkCheck.class.getClassLoader());
    }
}
