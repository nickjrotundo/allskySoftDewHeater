#!/bin/bash

# Filename of the Python script
PYTHON_SCRIPT="dewHeater.py"

# Function to create dewHeater.py
create_python_script() {
    cat << EOF > $PYTHON_SCRIPT
#!/usr/bin/env python3
import threading
import multiprocessing
import time
import subprocess

def get_cpu_temperature():
    try:
        result = subprocess.run(['vcgencmd', 'measure_temp'], capture_output=True, text=True)
        temp_str = result.stdout
        return float(temp_str.split('=')[1].split("'")[0])
    except Exception as e:
        print(f"Error reading temperature: {e}")
        return None

def cpu_intensive_task(stop_event, max_temp):
    while not stop_event.is_set():
        if get_cpu_temperature() < max_temp:
            [x**2 for x in range(100000)] # Increase range if more intensity is needed
        else:
            time.sleep(60)  # Sleep for 60 seconds before rechecking the temperature

def main():
    MAX_TEMP = 60.0  # Maximum CPU temperature. Adjust to your preferences.
    stop_event = threading.Event()
    threads = [threading.Thread(target=cpu_intensive_task, args=(stop_event, MAX_TEMP)) for _ in range(multiprocessing.cpu_count())]
    for thread in threads:
        thread.start()

    try:
        while True:
            time.sleep(3600)
    except KeyboardInterrupt:
        stop_event.set()
        for thread in threads:
            thread.join()

if __name__ == "__main__":
    main()
EOF

    echo "$PYTHON_SCRIPT created."
}

# Function to install psutil
install_psutil() {
    echo "Installing psutil..."
    pip3 install psutil
}

# Function to make the script executable
make_executable() {
    echo "Making $PYTHON_SCRIPT executable..."
    chmod +x $PYTHON_SCRIPT
}

# Function to set up the cron job
setup_cron() {
    CRON_JOB="0 18 * * * /usr/bin/nice -n 10 \$PWD/$PYTHON_SCRIPT >/dev/null 2>&1\n0 8 * * * pkill -f $PYTHON_SCRIPT"
    (crontab -l 2>/dev/null; echo -e "$CRON_JOB") | crontab -
    echo "Cron job set up to run $PYTHON_SCRIPT from 6 PM to 8 AM daily."
}

# Function to start the script if currently between 6 PM and 8 AM
start_script_if_appropriate() {
    HOUR=$(date +"%H")
    if [ $HOUR -ge 18 ] || [ $HOUR -lt 8 ]; then
        echo "Starting $PYTHON_SCRIPT as current time is within the scheduled interval."
        /usr/bin/nice -n 10 ./$PYTHON_SCRIPT &
    else
        echo "Not starting $PYTHON_SCRIPT as it is outside the scheduled interval."
    fi
}

# Create and set up the Python script
create_python_script
make_executable

# Install psutil, set up cron job, and start script if appropriate
install_psutil
setup_cron
start_script_if_appropriate

echo "Installation and setup completed."
