FROM nginx:1.18-alpine
COPY index.html /usr/share/nginx/html/index.html
COPY cheatsheet.css /usr/share/nginx/html/cheatsheet.css
COPY terraform.js /usr/share/nginx/html/terraform.js
