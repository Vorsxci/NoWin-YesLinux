# Start Komorebi with High Priority
Start-Process "komorebic.exe" -ArgumentList "start" -Priority High -WindowStyle Hidden

# Start YASB with AboveNormal Priority
Start-Process "python.exe" -ArgumentList "$env:USERPROFILE\.yasb\src\main.py" -Priority AboveNormal -WindowStyle Hidden