#!/bin/bash

# Create monitored folder if not exists
mkdir -p monitored_folder

# Create required files
touch logs.txt old_state.txt new_state.txt

echo "==================================" | tee -a logs.txt
echo " File Monitoring Started..." | tee -a logs.txt
echo " Started at: $(date)" | tee -a logs.txt
echo "==================================" | tee -a logs.txt

# Initial Scan using SHA256 hashes
find . -type f ! -name "old_state.txt" ! -name "new_state.txt" ! -name "logs.txt" -exec sha256sum {} \; | sort > old_state.txt

# Continuous Monitoring
while true
do
    # Current Scan
    find . -type f ! -name "old_state.txt" ! -name "new_state.txt" ! -name "logs.txt" -exec sha256sum {} \; | sort > new_state.txt

    # Compare old and new states
    changes=$(diff old_state.txt new_state.txt)

    # If changes detected
    if [ ! -z "$changes" ]
    then
        echo "" | tee -a logs.txt
        echo "==================================" | tee -a logs.txt
        echo " Change Detected!" | tee -a logs.txt
        echo " Time: $(date)" | tee -a logs.txt
        echo "==================================" | tee -a logs.txt

        echo "$changes" | tee -a logs.txt

        echo "==================================" | tee -a logs.txt

        # Update old state
        cp new_state.txt old_state.txt
    fi

    sleep 5
done
