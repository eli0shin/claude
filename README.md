# Claude Code Configuration

Personal Claude Code configuration and utility scripts for enhanced development workflow.

## Files

- **CLAUDE.md** - Personal coding instructions and guidelines for Claude
- **settings.example.json** - Example Claude Code settings configuration
- **extract_usage.sh** - Script to extract and format token usage from conversation transcripts
- **statusline-command.sh** - Custom status line command that displays model and token usage
- **.gitignore** - Git ignore configuration using selective include pattern

## Setup

1. Copy the example settings to create your personal configuration:
   ```bash
   cp settings.example.json settings.json
   ```

2. Make sure the utility scripts are executable:
   ```bash
   chmod +x extract_usage.sh statusline-command.sh
   ```

3. The configuration will automatically be used by Claude Code when placed in `~/.claude/`

## Features

- **Token Usage Tracking**: Real-time display of conversation token usage with percentage of context window
- **Custom Status Line**: Shows current model and token usage in a clean format
- **Coding Guidelines**: Consistent coding practices and instructions for Claude