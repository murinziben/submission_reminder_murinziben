#!/bin/bash

echo "Enter your name:"
read username

if [[ -z "$username" ]]; then
  echo "Name cannot be empty."
  exit 1
fi

APP_DIR="submission_reminder_${username}"
if [[ -d "$APP_DIR" ]]; then
  echo "Directory $APP_DIR already exists. Remove it or use a different name."
  exit 1
fi
mkdir -p "$APP_DIR"/{config,app,modules,assets}

# Copy or create the files with provided contents 
cp config.env "$APP_DIR/config/config.env"
cp reminder.sh "$APP_DIR/app/reminder.sh"
cp functions.sh "$APP_DIR/modules/functions.sh"
cp submissions.txt "$APP_DIR/assets/submissions.txt"

# Add 5 more student records to test 
echo -e "Kamanzi Alice,Git,Not Submitted\nMugisha Eric,Shell Navigation,Submitted\nUwase Nina,Shell Novis,Not Submitted\nHakizimana Jean,Git,Not Submitted\nMukamana Lea,Shell Novis,Submitted" >> "$APP_DIR/assets/submissions.txt"
# Create the startup.sh file
cat << 'EOL' > "$APP_DIR/startup.sh"
#!/bin/bash
cd $(dirname "$0")
bash ./app/reminder.sh
source "./modules/functions.sh"
source "./app/reminder.sh"
EOL

find "$APP_DIR" -type f -name "*.sh" -exec chmod +x {} \;
chmod +x "$APP_DIR/assets/submissions.txt"
chmod +x "$APP_DIR/modules/functions.sh"
echo "Environment created in $APP_DIR."

