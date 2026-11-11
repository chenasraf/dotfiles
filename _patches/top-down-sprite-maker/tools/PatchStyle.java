import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HexFormat;
import java.util.zip.ZipFile;

/**
 * Writes a copy of Style.class from tdsm.jar whose firstIncludedSprite returns null instead of
 * handing renderSprite a null direction or animation. That happens when directionInclusion holds
 * a direction that directionOrder lacks: the NPE kills the game loop thread and the window stops
 * responding. A null return already means "nothing to preview" to every caller.
 *
 * The rewrite swaps bytes in place rather than going through a bytecode library, so it builds on
 * any JDK. Fails unless the original instructions occur exactly once.
 *
 * Usage: PatchStyle <tdsm.jar> <output classes dir>
 */
public class PatchStyle {
    static final String ENTRY = "com/jordanbunke/tdsm/data/style/Style.class";

    // firstIncludedSprite, offsets 119-140: assert dir != null && anim != null;
    static final byte[] ORIGINAL = HexFormat.of().parseHex(
            "b2027b"                   // 119 getstatic $assertionsDisabled
            + "9a0013"                 // 122 ifne 141
            + "2b" + "c60007"          // 125 aload_1; ifnull 133
            + "2c" + "c7000b"          // 129 aload_2; ifnonnull 141
            + "bb027e" + "59"          // 133 new AssertionError; dup
            + "b70280" + "bf");        // 137 invokespecial <init>; athrow

    // if (dir == null || anim == null) return null;
    // Same length, and every branch lands on 133 or 141, the offsets the method's StackMapTable
    // already holds frames for, so the class still verifies.
    static final byte[] PATCHED = HexFormat.of().parseHex(
            "2b" + "c6000d"            // 119 aload_1; ifnull 133
            + "2c" + "c70011"          // 123 aload_2; ifnonnull 141
            + "000000000000"           // 127 nop x6
            + "01"                     // 133 aconst_null
            + "000000000000"           // 134 nop x6
            + "b0");                   // 140 areturn

    public static void main(String[] a) throws Exception {
        byte[] cls;
        try (ZipFile jar = new ZipFile(a[0])) {
            cls = jar.getInputStream(jar.getEntry(ENTRY)).readAllBytes();
        }

        int at = indexOf(cls, ORIGINAL, 0);
        if (at < 0 || indexOf(cls, ORIGINAL, at + 1) >= 0)
            throw new IllegalStateException("firstIncludedSprite does not match the expected bytecode; this tdsm.jar needs a new patch");
        System.arraycopy(PATCHED, 0, cls, at, PATCHED.length);

        Path out = Path.of(a[1], ENTRY);
        Files.createDirectories(out.getParent());
        Files.write(out, cls);
    }

    static int indexOf(byte[] haystack, byte[] needle, int from) {
        outer:
        for (int i = from; i <= haystack.length - needle.length; i++) {
            for (int j = 0; j < needle.length; j++)
                if (haystack[i + j] != needle[j]) continue outer;
            return i;
        }
        return -1;
    }
}
