# Top Down Sprite Maker fixes

Two bugs in Top Down Sprite Maker 1.3.1 (`com.jordanbunke.tdsm`) freeze the app. `apply.sh`
builds `tdsm-fixes.jar`, installs it into the app bundle ahead of `tdsm.jar` on the classpath, and
re-signs the bundle. The `top-down-sprite-maker` sofmani step runs it, and runs it again once an app
update replaces the bundle.

| Freeze | Cause | Fix |
|---|---|---|
| "Choose folder" on the export screen | The game loop thread shows a `JFileChooser`; its `pack()` and the EDT's directory reload take the AWT tree lock and `AquaFileSystemModel`'s lock in opposite orders and deadlock | `src/.../GenericFileDialog.java` shadows the app's class and shows the dialog on the EDT |
| Export-screen preview | `Style.firstIncludedSprite` passes a null direction to `renderSprite` when a direction is included but missing from the direction order; the NPE ends the game loop thread | `tools/PatchStyle.java` rewrites that method to return null, which callers read as "no preview" |

The app writes stderr to `/dev/null`, so a dead game loop leaves no trace. The window stays up and
ignores input. Run `jstack <pid>` to tell the two apart: the first freeze shows a Java-level
deadlock, and the second shows no `execution loop` thread.

```sh
sh apply.sh           # build and install
sh apply.sh --check   # exit 0 when installed and current
```

`PatchStyle` fails when `firstIncludedSprite` no longer matches the bytecode it expects, and
`javac` fails when the app's `IFileDialog` changes. Either way, the new app version needs both
patches re-derived rather than applied blind.

To remove the fixes, delete the `tdsm-fixes.jar` line from `Contents/app/Top Down Sprite Maker.cfg`,
delete `tdsm-fixes.jar` and `tdsm-fixes.stamp`, then re-sign with
`codesign --force --sign - "/Applications/Top Down Sprite Maker.app"`.
