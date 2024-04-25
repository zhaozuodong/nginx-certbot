# nginx-certbot
docker环境中通过cerbot工具，为.conf配置文件中所有域名申请免费的ssl证书，并自动更新过期的ssl证书

## docker 使用
```
docker run -d --name nginx-certbot \
 -v {your_path}/nginx.conf:/etc/nginx/nginx.conf \
 -v {your_path}/conf.d:/etc/nginx/conf.d \
 -v {your_path}/html:/usr/share/nginx/html \ 
 -v {your_path}/logs:/var/log/nginx \ 
 -v {your_path}/letsencrypt:/etc/letsencrypt \
 -p 80:80 \
 -p 443:443 \
 zhaozuodong/nginx-certbot:latest
```

## conf文件
在`{your_path}/conf.d`文件夹下，创建 `example.conf` 配置文件，只需要配置80端口的服务，程序会自动将ssl证书添加进配置文件, 并将80端口重定向到443端口。
```
server {
    listen 80;
    server_name {your_domain};

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```