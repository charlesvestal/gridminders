# GridMinders

GridMinders is a simple macOS SwiftUI app that visualizes your Apple Reminders in an Eisenhower 2x2 grid.
The reminders list updates automatically whenever tasks change in the Reminders app or sync via iCloud, so the grid stays current.

The app requests permission to access the Reminders database using `EventKit`. Completed tasks are filtered out so only open reminders appear. Tasks are categorized as:

- **Important** if they have the highest priority.
- **Urgent** if they are due today or within the next 24 hours.

The four quadrants are:

1. Important & Urgent
2. Important & Not Urgent
3. Not Important & Urgent
4. Not Important & Not Urgent

Click the checkmark next to a task to mark it complete. Double-click a task to open it directly in the Reminders app.
You can also drag a reminder from one quadrant to another:
- Dropping a reminder into an important quadrant automatically marks it high
  priority.
- Dropping one into an urgent quadrant assigns it a due date of today.
- Dragging an urgent reminder into a non‑urgent quadrant removes its due date.

## Building

The project is a Swift Package. Open the directory in Xcode (12 or later) or build from the command line:

```bash
swift build
```

Running the resulting executable will launch the GridMinders app.
