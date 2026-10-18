#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 1

# 이미 설치돼 있으면 건너뜀
if ! command -v donsetch >/dev/null; then
  rm -rf /tmp/donsetch
  git clone --depth 1 https://github.com/dondai44423/donsetch.git /tmp/donsetch &&
    cargo install --path /tmp/donsetch
fi

if command -v donsetch >/dev/null; then
  echo "setup done" >>/tmp/setup.log
else
  echo "setup failed (donsetch not installed)" >>/tmp/setup.log
fi
exit 0
