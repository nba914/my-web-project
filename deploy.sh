#!/bin/bash

# 1. 免死金牌：擊殺舊的網頁貨櫃（注意：不是擊殺 Jenkins 喔，是擊殺 Nginx 網頁貨櫃！）
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 安全搬運：把 Jenkins 剛拉下來的最新網頁檔案，隔空複製到對外的安全專區
# 💡 注意：請把底下的「dio-html-pipeline」改成你實際在 Jenkins 看到的專案資料夾名稱！
cp -r /var/jenkins_home/workspace/dio-html-pipeline/* /home/ubuntu/dio_company_center/web_code/

# 3. 點火重生：讓 Nginx 網頁貨櫃死死掛載在「純淨的 web_code」
docker run -d \
  --name my-html-web \
  -p 80:80 \
  -v /home/ubuntu/dio_company_center/web_code:/usr/share/nginx/html \
  nginx:alpine
