#!/bin/bash
# 1. 擊殺舊的 Nginx 網頁貨櫃
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 物理毀滅：直接把舊的保險箱炸毀！徹底清除所有可能殘留的 Nginx 歡迎頁
docker volume rm dio-web-pool || true
docker volume create dio-web-pool

# 3. 安全搬運：把 Jenkins 拉下來的專案網頁，灌進這個保鮮期 100% 全新的保險箱
docker run --rm \
  -v /var/jenkins_home/workspace/dio-html-pipeline/:/from \
  -v dio-web-pool:/to \
  alpine sh -c "cp -r /from/* /to/"

# 4. 點火重生：以標準平民安全模式啟動，抱住絕對純淨的 dio-web-pool
docker run -d \
  --name my-html-web \
  -p 80:80 \
  -v dio-web-pool:/usr/share/nginx/html \
  nginx:alpine
