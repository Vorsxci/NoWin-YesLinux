# Stop any lingering background instances
komorebic stop

# Start komorebi daemon with whkd and bar
komorebic start --whkd

# Brief delay to allow IPC socket binding
Start-Sleep -Milliseconds 500

# Apply runtime settings deprecated from JSON
komorebic focus-follows-mouse enable
komorebic mouse-follows-focus enable
