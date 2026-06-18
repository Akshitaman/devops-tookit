#!/bin/bash

# ─── Load shared config ───────────────────────────────────────
TOOLKIT_DIR="/mnt/c/Users/amana/OneDrive/Coding/Desktop/DevOps/devops-toolkit"
source "$TOOLKIT_DIR/config.sh"

# ─── Section 1: Good morning ──────────────────────────────────
echo "=================================="
echo "  MISSION CONTROL — GOOD MORNING"
echo "  $(date '+%A, %d %B %Y — %H:%M')"
echo "=================================="

# ─── Section 2: Docker status ─────────────────────────────────
echo ""
echo "--- DOCKER STATUS ---"
if docker info > /dev/null 2>&1; then
    RUNNING=$(docker ps --format "{{.Names}}" | wc -l)
    echo "✅  Docker is running — $RUNNING container(s) active"
else
    echo "⚠️   Docker is NOT running — start Docker Desktop manually"
fi

# ─── Section 3: Git status scan ───────────────────────────────
echo ""
echo "--- GIT STATUS ---"
for project in "$PROJECTS_DIR"/*/; do
    if [ -d "$project/.git" ]; then
        PROJECT_NAME=$(basename "$project")
        STATUS=$(git -C "$project" status --porcelain)
        if [ -z "$STATUS" ]; then
            echo "✅  $PROJECT_NAME — clean"
        else
            COUNT=$(echo "$STATUS" | wc -l)
            echo "⚠️   $PROJECT_NAME — $COUNT uncommitted files"
        fi
    fi
done

# ─── Section 4: Disk space ────────────────────────────────────
echo ""
echo "--- DISK SPACE ---"
df -h /mnt/c/ | awk 'NR==2 {print "💾  C: Drive — " $5 " used (" $4 " free)"}'

# ─── Section 5: Open VS Code ──────────────────────────────────
echo ""
echo "--- OPENING ENVIRONMENT ---"
code "$PROJECTS_DIR"
echo "✅  VS Code opened in DevOps folder"

# ─── Section 6: Open Brave at dashboard ───────────────────────
cmd.exe /c start brave "http://localhost:5001" 2>/dev/null
echo "✅  Brave opened at Mission Control dashboard"

# ─── Section 7: Log the run ───────────────────────────────────
echo ""
echo "[$(date '+%Y-%m-%d %H:%M')] launcher.sh ran successfully" >> "$LOG_DIR/launcher.log"
echo "--- DONE — Happy coding Akshit 🚀 ---"