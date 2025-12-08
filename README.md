# check-claude-usage

A Bash script to check your current Anthropic API usage.

## Description

This script makes a minimal API call to the Anthropic Messages API and displays the rate limit headers from the response. This provides a quick way to see your current usage and remaining capacity.

## Requirements

- Bash
- curl
- An Anthropic API key

## Installation

1. Clone or download the script
2. Make it executable: `chmod +x check-claude-usage.sh`
3. (Optional) Add this directory to your PATH

## Usage

```bash
export ANTHROPIC_API_KEY="your-api-key"
./check-claude-usage.sh
```

## Output

The script displays rate limit information including:

- `requests-limit` - Maximum requests allowed per period
- `requests-remaining` - Requests remaining in current period
- `requests-reset` - When the request limit resets
- `tokens-limit` - Maximum tokens allowed per period
- `tokens-remaining` - Tokens remaining in current period
- `tokens-reset` - When the token limit resets

## Configuration

The script uses the following defaults which can be modified in the source:

- `ANTHROPIC_VERSION` - API version (default: `2023-06-01`)
- `CLAUDE_MODEL` - Model used for the check (default: `claude-haiku-4-5-20251001`)

## License

MIT

## Maintainer

Matt Fields <hello@mattfields.dev>
