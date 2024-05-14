args="$@"

API_KEY="your-api-key"
MODEL="gpt-4o"

MESSAGE="Respond with the most suitable terminal command based on this query: <query>$args</query> Only return the command and nothing else. Do not wrap command in bash\nsudo"

RESPONSE=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $API_KEY" \
-d "{
\"model\": \"$MODEL\",
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

if echo "$RESPONSE" | grep -q '"error"'; then
  echo "An error occurred:"
  echo "$RESPONSE" | awk -F: '/"message":/{gsub(/"|,/,""); print $2}'
  exit 1
fi

COMMAND=$(echo "$RESPONSE" | awk -F: '/"content":/{gsub(/"|,/,""); print $2}')open

echo "I'm going to run the following command: $COMMAND"
read -p "Do you want to continue? (Y/n) " choice

case "$choice" in 
  n|N ) echo "Aborting..."; exit 1;;
  * ) echo "Executing the command..."; eval $COMMAND;;
esac