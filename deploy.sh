#!/bin/bash
# 1. 透過 Docker 襪子（sock）直接擊殺外面的 Nginx 網頁貨櫃
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 安全搬運：從 Jenkins 自己的工作區，搬到剛剛開闢的內部門戶 /var/web_code
#  這樣一搬，宿主機的實體 web_code 資料夾就會隔空同步收到檔案！
cp -r /var/jenkins_home/workspace/dio-html-pipeline/* /var/web_code/

# 3. 啟動 Nginx：讓 Nginx 抱住宿主機實體的 web_code
docker run -d \
  --name my-html-web \
  --user 1000:1000 \
  -p 80:80 \
  -v /home/ubuntu/dio_company_center/web_code:/usr/share/nginx/html \
  nginx:alpine
