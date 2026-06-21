#!/bin/bash
# 1. 擊殺舊的 Nginx 網頁貨櫃
docker stop my-html-web || true
docker rm my-html-web || true

# 2. 安全搬運：把工廠拉下來的東西，搬到對外的 /var/web_code
cp -r /var/jenkins_home/workspace/dio-html-pipeline/* /var/web_code/

# 3. 終極點火：讓 Nginx 用平民身分（1000）去聽它內部的 8080 埠！
# 💡 這樣它既能跨進 700 的大門，又不會因為搶 80 埠而暴斃！
# 💡 注意看連接埠映射變成了：-p 80:8080 (外面依然是80，裡面走8080)
docker run -d \
  --name my-html-web \
  --user 1000:1000 \
  -p 80:8080 \
  -v /home/ubuntu/dio_company_center/web_code:/usr/share/nginx/html \
  nginx:alpine
