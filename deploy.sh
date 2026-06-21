#!/bin/bash
# 1. 擊殺舊的 Nginx 網頁貨櫃
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 安全搬運：直接把 Jenkins 拉下來的網頁，丟進 Docker 託管的獨立保險箱（dio-web-pool）
# 💡 這樣做，完全繞開了宿主機實體資料夾的 700 權限阻擋！
docker run --rm \
  -v /var/jenkins_home/workspace/dio-html-pipeline/:/from \
  -v dio-web-pool:/to \
  alpine sh -c "cp -r /from/* /to/"

# 3. Nginx 點火：用標準平民模式啟動，直接抱住 dio-web-pool 保險箱
# 💡 沒開 --user root！走標準 -p 80:80！完全不破壞宿主機 700 權限！
docker run -d \
  --name my-html-web \
  -p 80:80 \
  -v dio-web-pool:/usr/share/nginx/html \
  nginx:alpine
