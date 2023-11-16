#!/usr/bin/env zsh

typeset -g APP_BASE_PATH=$(pwd); source src/utils/autoload.zsh || exit 1

# Define the path to your .env file
ENV_FILE="${APP_BASE_PATH}/.env"

# Check if the .env file exists
if [[ -f "$ENV_FILE" ]]; then
    # Export the environment variables
    while IFS= read -r line || [[ -n $line ]]; do
        # Skip empty lines and lines starting with a comment
        if [[ -z "$line" || "$line" == \#* ]]; then
            continue
        fi
        # Use typeset to make sure the environment variable name is valid
        typeset -x "$line"
    done < "$ENV_FILE"
else
    echo "Error: .env file does not exist."
    exit 1
fi

# Now you can use the environment variables as usual
echo "Username: $USERNAME"
echo "Password: $PASSWORD"