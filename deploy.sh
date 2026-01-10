#!/bin/bash

# 习惯追踪插件部署脚本

set -e

PLUGIN_NAME="obsidian-habit-tracker"
PLUGIN_ID="obsidian-habit-tracker"

echo "🚀 开始部署 $PLUGIN_NAME 插件..."

# 定义基础路径
BASE_PATH="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/漂泊者及其影子"
NOTE_DEMO_PATH="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/note-demo"

# 定义目标 vault 目录
VAULTS=(
  "$BASE_PATH/.obsidian-mobile/plugins"
  "$BASE_PATH/.obsidian-pro/plugins"
  "$BASE_PATH/.obsidian-ipad/plugins"
  "$BASE_PATH/.obsidian-2017/plugins"
  "$BASE_PATH/.obsidian-zhang/plugins"
  "$NOTE_DEMO_PATH/.obsidian/plugins"
)

# 需要复制的文件
ALWAYS_COPY_FILES=(
  "dist/main.js:main.js"
  "manifest.json"
  "styles.css"
  "config.json"
)

SUCCESS_COUNT=0
FAILED_COUNT=0

# 部署到每个 vault
for vault in "${VAULTS[@]}"; do
  if [ -d "$vault" ]; then
    echo "📦 部署到: $vault"
    
    # 创建插件目录
    mkdir -p "$vault/$PLUGIN_ID"
    
    # 复制所有文件
    for file in "${ALWAYS_COPY_FILES[@]}"; do
      if [[ "$file" == *":"* ]]; then
        source_file="${file%:*}"
        target_file="${file#*:}"
        if [ -f "$source_file" ]; then
          cp "$source_file" "$vault/$PLUGIN_ID/$target_file"
          echo "  ✓ 复制 $source_file → $target_file"
        else
          echo "  ⚠️  警告: $source_file 不存在"
        fi
      else
        if [ -f "$file" ]; then
          cp "$file" "$vault/$PLUGIN_ID/"
          echo "  ✓ 复制 $file"
        else
          echo "  ⚠️  警告: $file 不存在"
        fi
      fi
    done
    
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    echo "  ✅ 部署成功"
  else
    echo "❌ 目录不存在: $vault"
    FAILED_COUNT=$((FAILED_COUNT + 1))
  fi
  echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 部署总结"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 成功: $SUCCESS_COUNT 个 vault"
echo "❌ 失败: $FAILED_COUNT 个 vault"
echo ""
echo "💡 提示: 在 Obsidian 中重新加载插件以查看更改"
echo "   - 打开命令面板 (Cmd/Ctrl + P)"
echo "   - 搜索 'Reload app without saving'"
echo "   - 或者禁用再启用插件"
