# GridMinders

GridMinders is a simple macOS SwiftUI app that visualizes your Apple Reminders in an Eisenhower 2x2 grid.

The app requests permission to access the Reminders database using `EventKit`. Tasks are categorized as:

- **Important** if they are flagged or have high priority.
- **Urgent** if they are due today or within the next 24 hours.

The four quadrants are:

1. Important & Urgent
2. Important & Not Urgent
3. Not Important & Urgent
4. Not Important & Not Urgent

## Building

The project is a Swift Package. Open the directory in Xcode (12 or later) or build from the command line:

```bash
swift build
```

Running the resulting executable will launch the GridMinders app.
