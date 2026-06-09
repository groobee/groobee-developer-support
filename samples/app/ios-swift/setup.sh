#!/usr/bin/env bash
#
# GroobeeSample(iOS) 프로젝트 생성 스크립트
#   xcodegen generate  →  pod install
#
set -e
cd "$(dirname "$0")"

# CocoaPods 가 UTF-8 로케일을 요구합니다 (ASCII-8BIT 환경에서 오류 방지)
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "❌ xcodegen 이 필요합니다.  설치: brew install xcodegen"
  exit 1
fi

if ! command -v pod >/dev/null 2>&1; then
  echo "❌ CocoaPods 가 필요합니다.  설치: sudo gem install cocoapods"
  exit 1
fi

# 설정 파일이 없으면 예시에서 복사 (값은 직접 채워야 합니다)
if [ ! -f GroobeeSample/Secrets.plist ]; then
  cp GroobeeSample/Secrets.example.plist GroobeeSample/Secrets.plist
  echo "ℹ️  GroobeeSample/Secrets.plist 를 생성했습니다. 서비스키/캠페인키를 채워주세요."
fi

echo "▶ xcodegen generate"
xcodegen generate

echo "▶ pod install"
# 로컬 스펙 인덱스가 오래되어 GroobeeKit 을 못 찾으면 --repo-update 로 재시도
pod install || pod install --repo-update

echo ""
echo "✅ 완료!  아래 워크스페이스를 Xcode 로 여세요:"
echo "   open GroobeeSample.xcworkspace"
