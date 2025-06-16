#!/bin/bash

echo "Enter your name:"
read user_name

dir_name="submission_reminder_$user_name"

mkdir -p "$dir_name"/{app,modules,assets,config}

cat > "$dir_name/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

cat > "$dir_name/modules/functions.sh" << 'EOF'
#!/bin/bash

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"
    
    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)
        
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF

cat > "$dir_name/app/reminder.sh" << 'EOF'
#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

cat > "$dir_name/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Michael, Shell Navigation, not submitted
Sarah, Git, not submitted
John, Shell Navigation, submitted
Emma, Shell Basics, not submitted
David, Shell Navigation, not submitted
EOF

cat > "$dir_name/startup.sh" << 'EOF'
#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f "config/config.env" ]; then
    echo "Error: config.env not found"
    exit 1
fi

if [ ! -f "assets/submissions.txt" ]; then
    echo "Error: submissions.txt not found"
    exit 1
fi

echo "Starting Submission Reminder Application"
echo "========================================"

./app/reminder.sh
EOF

find "$dir_name" -name "*.sh" -exec chmod +x {} \;

echo "Environment created successfully in $dir_name"
echo "To test the application, run:"
echo "cd $dir_name && ./startup.sh"
