#!/bin/bash

# Prompt the user for their folder name
read -p "Enter the name used in your workspace folder: " username

# Make sure the input isn't empty
if [ -z "$username" ]; then
    echo "Oops! You forgot to type something "
    echo "Exiting now..."
    exit 1
fi

# Only letters and spaces allowed
if ! [[ "$username" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "Names should contain letters and spaces only "
    echo "Exit initiated..."
    exit 1
fi

# Set workspace and important file paths
workspace="submission_reminder_$username"
records_file="$workspace/assets/submissions.txt"
env_config="$workspace/config/config.env"

# Confirm the folder exists
if [ ! -d "$workspace" ]; then
    echo "Workspace '$workspace' does not exist "
    echo "Have you created the environment yet?"
    echo "Closing script..."
    exit 1
fi

# Ask for the task name and remaining days
read -p "Assignment title: " task_name
read -p "Days left until submission: " deadline_days

# Clean up the values
task_name=$(echo "$task_name" | tr -cd '[:alnum:] [:space:]' | xargs)
deadline_days=$(echo "$deadline_days" | xargs)

echo "DEBUG → Task: '$task_name' | Deadline: $deadline_days days"

# Make sure both fields are valid
if [ -z "$task_name" ] || [ -z "$deadline_days" ]; then
    echo "You need to fill in both fields "
    echo "Try again..."
    exit 1
fi

if ! [[ "$deadline_days" =~ ^[0-9]+$ ]]; then
    echo "Number of days should be digits only "
    exit 1
fi

# Search for the assignment in the record
confirmed_task=$(grep -i ", *$task_name," "$records_file" | awk -F',' '{print $2}' | xargs | head -n1)

if [ -z "$confirmed_task" ]; then
    echo "We couldn't find '$task_name' in the submissions list "
    echo "Make sure the name is correct."
    exit 1
fi

# Save values to the config
echo "Writing updated details to config file... "
echo "ASSIGNMENT=\"$confirmed_task\"" > "$env_config"
echo "DAYS_REMAINING=$deadline_days" >> "$env_config"

echo " All set! Here's your config:"
cat "$env_config"
echo "---------------------------------------------"

# Ask if user wants to launch the reminder system
read -p "Do you want to run the app now? (y/n): " start_choice

if [[ "$start_choice" =~ ^[Yy]$ ]]; then
    echo "Launching your reminder system "
    bash "$workspace/startup.sh"
    echo " Reminder is now running!"
else
    echo "No worries. You can run it anytime with:"
    echo "bash $workspace/startup.sh"
    echo "Have a good one "
fi
