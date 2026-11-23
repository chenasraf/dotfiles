// Prints "<window-id> <x> <y> <width> <height>" for each on-screen window whose
// owning app name starts with the first argument.
import CoreGraphics

let prefix = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
let windows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID)
  as? [[String: Any]] ?? []
for w in windows where (w["kCGWindowOwnerName"] as? String ?? "").hasPrefix(prefix) {
  guard (w["kCGWindowLayer"] as? Int ?? 0) == 0,
    let b = w["kCGWindowBounds"] as? [String: Any]
  else { continue }
  print(w["kCGWindowNumber"]!, b["X"]!, b["Y"]!, b["Width"]!, b["Height"]!)
}
