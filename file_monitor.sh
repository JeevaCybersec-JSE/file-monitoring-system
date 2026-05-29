#!/bin/bash

# Create monitored folder if not exists
mkdir -p monitored_folder

# Create required files
touch logs.txt old_state.txt new_state.txt

echo "==================================" | tee -a logs.txt
echo " File Monitoring Started..." | tee -a logs.txt
echo " Started at: $(date)" | tee -a logs.txt
echo "==================================" | tee -a logs.txt

# Initial Scan
find monitored_folder -type f | sort > old_state.txt

# Continuous Monitoring
while true
do
    # Current Scan
    find monitored_folder -type f | sort > new_state.txt

    # Compare files
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
