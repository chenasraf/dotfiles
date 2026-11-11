package com.jordanbunke.sorkin;

import javax.swing.JFileChooser;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.lang.reflect.InvocationTargetException;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.IntSupplier;

/**
 * Replaces the class of the same name in tdsm.jar by coming first on the classpath.
 * The app shows this dialog from its game loop thread, where pack() holds the AWT tree lock
 * while asking AquaFileSystemModel for its row count. The EDT takes those locks in the opposite
 * order when a directory reload completes, so the two threads deadlock. Showing the dialog on
 * the EDT leaves a single thread taking both locks.
 */
public final class GenericFileDialog extends JFileChooser implements IFileDialog {
    @Override
    public void addFileFilter(String name, String... extensions) {
        setFileFilter(new FileNameExtensionFilter(name, extensions));
    }

    @Override
    public int showOpenDialog() {
        return onEdt(() -> showOpenDialog(null));
    }

    @Override
    public int showSaveDialog() {
        return onEdt(() -> showSaveDialog(null));
    }

    private static int onEdt(IntSupplier dialog) {
        if (SwingUtilities.isEventDispatchThread())
            return dialog.getAsInt();

        AtomicInteger result = new AtomicInteger(ERROR_OPTION);
        try {
            SwingUtilities.invokeAndWait(() -> result.set(dialog.getAsInt()));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (InvocationTargetException e) {
            e.getCause().printStackTrace();
        }
        return result.get();
    }
}
