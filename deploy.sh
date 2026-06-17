#!/bin/bash

echo "=================="
echo "網頁部署自動化啟動"
echo "=================="

echo "正在移除舊檔"
docker rm -f my-web-container 2>/dev/null

echo "正在更新ISO檔"
docker build -t my-web-image .

echo "正在更新伺服器"
docker run -d -p 80:80 --name my-web-container my-web-image

echo "======================="
echo "已成功更新 請刷新瀏覽器"
echo "======================="

