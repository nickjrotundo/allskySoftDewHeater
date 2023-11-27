
# Dew Heater Script for Raspberry Pi

## Description
This repository contains the `dewHeater.py` script, designed to increase the CPU usage of a Raspberry Pi to generate heat. This is particularly useful for preventing dew formation on an allsky camera's acrylic dome. The script includes a safety feature to ensure the CPU temperature does not exceed 60°C. Tested on Raspberry Pi 4B running Debian Bookworm.

## Installation
The installation process is automated through the `install.sh` script, which will install `dewHeater.py` in your current directory.

### Steps to Install:
1. **Download the Installation Script**:
   Use `wget` to download the `install.sh` script from this repository:

   Using `wget`:
   ```bash
   wget https://raw.githubusercontent.com/nickjrotundo/allskySoftDewHeater/main/install.sh
   ```

2. **Make the Script Executable**:
   Change the script's permissions to make it executable:
   ```bash
   sudo chmod +x install.sh
   ```

3. **Run the Installation Script**:
   Execute the script:
   ```bash
   sudo ./install.sh
   ```

## Post-Installation Checks
- **Cron Job**: Verify the cron job setup with `crontab -l`. The script should run daily between 6 PM and 8 AM.
- **Script Execution**: Use `ps aux | grep dewHeater.py` to check if the script is running.
- **Temperature Monitoring**: Monitor the CPU temperature, especially during the first few days, to ensure it stays within safe limits.

## Optional: Creating and Running the tempCheck.sh Script
To monitor your Raspberry Pi's CPU temperature, throttling status, and voltage in real-time, you can create and run a script named `tempCheck.sh`. 

1. **Create the tempCheck.sh Script**:
   Create a new script file and open it with a text editor:
   ```bash
   nano tempCheck.sh
   ```
   Copy and paste the following content into the editor:
   ```bash
   #!/bin/bash

   # Run this in a loop
   while true; do
       clear
       # Display CPU Temperature
       echo "CPU Temperature: \$(vcgencmd measure_temp)"
       # Display Throttling Status
       echo "Throttling Status: \$(vcgencmd get_throttled)"
       # Display Voltage
       echo "Voltage: \$(vcgencmd measure_volts core)"
       echo
       # Display CPU usage via 'top' for a brief moment
       top -bn1 | head -15
       # Refresh every 5 seconds
       sleep 5
   done
   ```
   Save and exit the editor (in `nano`, it's Ctrl+O, Enter to save and Ctrl+X to exit).

2. **Make tempCheck.sh Executable**:
   ```bash
   chmod +x tempCheck.sh
   ```

3. **Run tempCheck.sh**:
   To start monitoring, run the script:
   ```bash
   ./tempCheck.sh
   ```
   To stop the script, press Ctrl+C.

## Tips and Debugging
- **Location**: Run `install.sh` in a directory where you have write permissions.
- **Python Dependencies**: The script requires `psutil`. Ensure that Python 3 and `pip` are installed.
- **Temperature Threshold**: The default safety threshold is set at 60°C. This can be adjusted in the `dewHeater.py` script.
- **Error Handling**: If you encounter permission-related errors, consider running the script with `sudo` or check the directory permissions.
- **Force Stopping**: To stop `dewHeater.py` manually, find its process ID with `ps aux | grep dewHeater.py` and terminate it using `kill [PID]`.
- **Log Files**: Redirect output to a log file for troubleshooting, e.g., `./dewHeater.py > dewHeater.log 2>&1`.


