#!/usr/bin/env zsh
# zsh-clash - A zsh plugin that converts natural language to shell commands
# Powered by Claude Code CLI
#
# Usage: Type "# description" and press Enter
# Example: # find files larger than 1MB
#          -> find . -size +1M -exec ls -lh {} \;

# Configuration variables
: ${CLASH_DISABLED:=0}
: ${CLASH_MODEL:="haiku"}
: ${CLASH_DEBUG:=0}
: ${CLASH_FANCY_LOADING:=1}
: ${CLASH_PREFIX:="#"}

# Thinking verbs for loading animation
_clash_verbs=(
    "Thinking"
    "Generating"
    "Computing"
    "Processing"
    "Analyzing"
    "Interpreting"
    "Composing"
    "Reasoning"
    "Converting"
    "Crafting"
)

# Check if Claude CLI is available
_clash_check_cli() {
    if ! command -v claude &> /dev/null; then
        echo "Error: Claude CLI not found. Install it with:"
        echo "  curl -fsSL https://claude.ai/install.sh | bash"
        return 1
    fi
    return 0
}

# Spinner animation (runs in background)
_clash_spinner() {
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    local verb=${_clash_verbs[$((RANDOM % ${#_clash_verbs[@]} + 1))]}

    # Hide cursor
    printf '\033[?25l' > /dev/tty

    while true; do
        printf "\r\033[K%s %s..." "${spinstr:$i:1}" "$verb" > /dev/tty
        i=$(( (i + 1) % ${#spinstr} ))
        sleep 0.1
    done
}

# Stop spinner - only clear spinner line, preserve above
_clash_stop_spinner() {
    local pid=$1
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null
        sleep 0.05
    fi
    # Show cursor, clear only spinner line (don't go up)
    printf '\033[?25h\r\033[K' > /dev/tty
}

# Sanitize output - remove markdown code blocks and extra formatting
_clash_sanitize() {
    local input="$1"

    # Remove markdown code blocks (```bash, ```sh, ``` etc)
    input=$(echo "$input" | grep -v '^```')

    # Remove leading/trailing whitespace
    input=$(echo "$input" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

    # Take first non-empty line only
    input=$(echo "$input" | grep -v '^$' | head -n 1)

    echo "$input"
}

# Debug logging
_clash_debug() {
    if [[ $CLASH_DEBUG -eq 1 ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Main function to generate command from description
_clash_generate() {
    local description="$1"
    local output=""
    REPLY=""
    local claude_status=0
    local cmd_args=("-p" "--disable-slash-commands" "--no-session-persistence" "--tools" "")

    # Add model if specified
    if [[ -n "$CLASH_MODEL" ]]; then
        cmd_args+=("--model" "$CLASH_MODEL")
    fi

    # Build prompt
    local prompt="Generate a single shell command for: ${description}.
Output ONLY the command, no explanation, no markdown, no code blocks.
The command should work in zsh on macOS/Linux."

    cmd_args+=("$prompt")

    _clash_debug "Running: claude ${cmd_args[*]}"

    # Run Claude CLI
    local tmpfile
    local claude_pid=""
    local spinner_pid=""
    local interrupted=0
    tmpfile=$(mktemp)

    setopt local_options local_traps no_notify no_monitor
    trap 'interrupted=1; if [[ -n "$claude_pid" ]] && kill -0 "$claude_pid" 2>/dev/null; then kill -INT "$claude_pid" 2>/dev/null; fi' INT

    if [[ $CLASH_FANCY_LOADING -eq 1 ]]; then
        print > /dev/tty
        _clash_spinner &
        spinner_pid=$!
    fi

    claude "${cmd_args[@]}" > "$tmpfile" 2>/dev/null &
    claude_pid=$!

    while kill -0 "$claude_pid" 2>/dev/null; do
        if [[ $interrupted -eq 1 ]]; then
            kill -TERM "$claude_pid" 2>/dev/null
            sleep 0.2
            kill -KILL "$claude_pid" 2>/dev/null
        fi
        sleep 0.05
    done

    wait "$claude_pid" 2>/dev/null
    claude_status=$?
    trap - INT

    if [[ -n "$spinner_pid" ]]; then
        _clash_stop_spinner $spinner_pid
    fi

    if [[ $interrupted -eq 1 ]]; then
        claude_status=130
    fi

    output="$(<"$tmpfile")"
    rm -f "$tmpfile"

    if [[ $claude_status -ne 0 ]]; then
        return $claude_status
    fi

    # Sanitize output
    output=$(_clash_sanitize "$output")

    _clash_debug "Generated: $output"

    REPLY="$output"
    return 0
}

# Custom accept-line widget
_clash_accept_line() {
    # Skip if disabled
    if [[ $CLASH_DISABLED -eq 1 ]]; then
        zle .accept-line
        return
    fi

    local buffer="$BUFFER"
    local prefix="$CLASH_PREFIX"

    # Check if buffer starts with prefix (# by default)
    if [[ "$buffer" == "${prefix}"* ]] && [[ "$buffer" != "${prefix}" ]]; then
        # Skip if it's a shebang
        if [[ "$buffer" == "#!"* ]]; then
            zle .accept-line
            return
        fi

        # Skip multi-line buffers
        if [[ "$buffer" == *$'\n'* ]]; then
            zle .accept-line
            return
        fi

        # Check CLI availability
        if ! _clash_check_cli; then
            zle .accept-line
            return
        fi

        # Extract description (remove prefix and leading space)
        local description="${buffer#${prefix}}"
        description="${description#[[:space:]]}"

        if [[ -n "$description" ]]; then
            # Save original to history
            print -s "$buffer"

            # Generate command (spinner runs here)
            _clash_generate "$description"
            local generate_status=$?
            local generated_cmd="$REPLY"

            if [[ $generate_status -eq 130 ]]; then
                zle reset-prompt
                return
            fi

            if [[ -n "$generated_cmd" ]]; then
                # Set buffer with generated command
                BUFFER="$generated_cmd"
                CURSOR=${#BUFFER}
                zle reset-prompt
                return
            fi
        fi
    fi

    # Default behavior
    zle .accept-line
}

# Initialize the plugin
_clash_init() {
    # Create widget
    zle -N accept-line _clash_accept_line

    _clash_debug "clash initialized"
}

# Run initialization
_clash_init
