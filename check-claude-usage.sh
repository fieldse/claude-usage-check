#!/bin/bash
# Check Anthropic API rate limits by making a minimal API call and displaying usage headers

ANTHROPIC_VERSION="2023-06-01"
CLAUDE_MODEL="claude-haiku-4-5-20251001"

if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY environment variable not set"
    exit 1
fi

# Print usage information and exit
usage() {
    echo "Display current Anthropic API rate limit status"
    echo ""
    echo "Usage: $0"
    echo "Environment Variables:"
    echo "  ANTHROPIC_API_KEY   Your Anthropic API key (required)"
    exit 1
}

# Make a minimal API call to retrieve rate limit headers
# Exits on curl failure or non-200 response
function api_call() {
    local response
    response=$(curl -s -i -X POST https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: $ANTHROPIC_VERSION" \
        -H "content-type: application/json" \
        -d "{
            \"model\": \"$CLAUDE_MODEL\",
            \"max_tokens\": 1,
            \"messages\": [{\"role\": \"user\", \"content\": \"hi\"}]
        }") || {
        echo "Error: curl request failed"
        exit 1
    }
    if ! echo "$response" | head -n1 | grep -q "200"; then
        echo "Error: API returned non-200 status"
        echo "$response"
        exit 1
    fi
    echo "$response"
}

# Format ISO timestamp to readable date, or return original on failure
format_date() {
    date -d "$1" "+%Y-%m-%d %H:%M:%S %Z" 2>/dev/null || echo "$1"
}

# Parse and display rate limit headers from API response
print_usage_info() {
    echo ""
    echo "--------------------------------------------------"
    echo " Claude Usage Information:"
    echo "--------------------------------------------------"

    grep -i "anthropic-ratelimit" <<< "$1" | while read -r line; do
        header=$(cut -d: -f1 <<< "$line" | tr -d '\r' | sed 's/anthropic-ratelimit-//i')
        value=$(cut -d: -f2- <<< "$line" | sed 's/^[[:space:]]*//' | tr -d '\r')

        if grep -q "reset" <<< "$header"; then
            printf "%-30s %s\n" "$header" "$(format_date "$value")"
        else
            printf "%-30s %s\n" "$header" "$value"
        fi
    done
}

# Main entry point
main() {
    local response
    response=$(api_call)
    print_usage_info "$response"
}

main


