#!/bin/sh
# 키트를 과제 폴더에 설치한다. 클론한 폴더 이름(hynixfinal, .hynixfinal 등)과 상관없이 과제 폴더 루트에서 `sh <키트폴더>/install.sh`로 실행한다.
# 하는 일: 키트를 .hynixfinal/로 옮기고 키트의 .git을 지운다(과제 폴더의 평범한 하위 폴더로 제출되게).
#          AGENTS.md를 과제 폴더 루트에 놓고, Codex 권한 설정을 .codex/config.toml에 놓는다.
set -e

KIT=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$KIT")
cd "$ROOT"

if [ "$KIT" != "$ROOT/.hynixfinal" ]; then
  if [ -e .hynixfinal ]; then
    echo "이미 .hynixfinal 폴더가 있어 옮기지 않았다: $KIT" >&2
    exit 1
  fi
  mv "$KIT" .hynixfinal
fi
rm -rf .hynixfinal/.git

if [ ! -f AGENTS.md ]; then
  cp .hynixfinal/AGENTS.md AGENTS.md
elif ! grep -q "SK하이닉스 AI 해커톤 결선" AGENTS.md; then
  printf "\n" >> AGENTS.md
  cat .hynixfinal/AGENTS.md >> AGENTS.md
fi

# Codex 샌드박스는 .codex/ 쓰기를 막는다. 막히면 Codex가 승인을 받아 이 스크립트를 다시 실행하면 된다(다시 실행해도 안전하다).
if ! { mkdir -p .codex && { [ -f .codex/config.toml ] || cp .hynixfinal/codex-config.toml .codex/config.toml; }; } 2>/dev/null; then
  echo "규칙 설치는 끝났지만 .codex/config.toml 은 샌드박스에 막혀 못 놓았다. 승인을 받아 sh .hynixfinal/install.sh 를 다시 실행한다." >&2
  exit 2
fi

echo "설치 완료: .hynixfinal/, AGENTS.md, .codex/config.toml"
echo "Codex를 /quit 으로 끄고 codex 로 다시 켜야 규칙과 권한 설정이 적용된다."
