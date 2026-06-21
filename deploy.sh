#!/bin/bash
# 1. 擊殺舊的 Nginx 網頁貨櫃
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 安全搬運：清空舊數據，確保把工廠拉下來的最新專案網頁塞進 dio-web-pool
# 💡 加上 rm -rf /to/*，先把 Nginx 可能偷偷塞進去的歡迎頁屍體徹底炸毀！
docker run --rm \
  -v /var/jenkins_home/workspace/dio-html-pipeline/:/from \
  -v dio-web-pool:/to \
  alpine sh -c "rm -rf /to/* && cp -r /from/* /to/"

# 3. 點火重生：以標準平民安全模式啟動，抱住乾淨的 dio-web-pool
docker run -d \
  --name my-html-web \
  -p 80:80 \
  -v dio-web-pool:/usr/share/nginx/html \
  nginx:alpine
