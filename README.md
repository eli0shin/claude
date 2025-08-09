# Claude Code Configuration

Personal Claude Code configuration and utility scripts for enhanced development workflow.

## Files

- **CLAUDE.md** - Personal coding instructions and guidelines for Claude
- **settings.example.json** - Example Claude Code settings configuration
- **scripts/context_size.sh** - Script to extract and format token usage from conversation transcripts
- **scripts/statusline.sh** - Custom status line command that displays model and token usage
- **scripts/setup.sh** - Setup script to merge example settings with personal configuration
- **.gitignore** - Git ignore configuration using selective include pattern

## Setup

1. Run the setup script to configure your settings:
   ```bash
   ./scripts/setup.sh
   ```
   
   This will merge any new settings from `settings.example.json` into your `settings.json` while preserving existing customizations.

3. The configuration will automatically be used by Claude Code when placed in `~/.claude/`

## Features

- **Token Usage Tracking**: Real-time display of conversation token usage with percentage of context window
- **Custom Status Line**: Shows current model and token usage in a clean format
- **Coding Guidelines**: Consistent coding practices and instructions for Claude