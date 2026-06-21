#!/bin/bash
# 1. 擊殺舊的 Nginx 網頁貨櫃（確保埠口清空）
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 資安鐵律搬運：從 Jenkins 肚子，透過安全蟲洞實打實地複製到主機的 web_code！
# 💡 注意：我們一定要在啟動 Nginx 之前把檔案塞進去！
cp -r /var/jenkins_home/workspace/dio-html-pipeline/* /var/web_code/

# 3. 點火重生：讓 Nginx 滿血升空，一出生就咬住已經放好檔案的 web_code！
# 💡 因為您的 web_code 是 700 權限，而 Nginx 預設是 root 啟動，
# 💡 它能合法看穿 700，同時又跟 jenkins_data 達成了絕對的實體目錄隔離！
docker run -d \
  --name my-html-web \
  -p 80:80 \
  -v /home/ubuntu/dio_company_center/web_code:/usr/share/nginx/html \
  nginx:alpine
