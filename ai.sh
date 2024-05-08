args="$@"

API_KEY="your-api-key"

MESSAGE="Only respond with the most suitable command for the command-line terminal based on this goal: <goal>$args</goal> Only return the most suitable command as if the user wrote it themselves and nothing else. Do not wrap command in bash\nsudo"

RESPONSE=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $API_KEY" \
-d "{
\"model\": \"gpt-3.5-turbo\",
\"messages\": [
    {
    \"role\": \"system\",
    \"content\": \"You are a helpful assistant.\"
    },
    {
    \"role\": \"user\",
    \"content\": \"$MESSAGE\"
    }
]
}")

COMMAND=$(echo "$RESPONSE" | awk -F: '/"content":/{gsub(/"|,/,""); print $2}')

echo "$COMMAND"

echo "I'm going to run the following command: $COMMAND"
read -p "Do you want to continue? (Y/n) " choice

case "$choice" in 
  n|N ) echo "Aborting..."; exit 1;;
  * ) echo "Executing the command..."; eval $COMMAND;;
esac