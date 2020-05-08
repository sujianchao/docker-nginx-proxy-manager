# nginx-proxy-manager Dockerfile
# Fork of jlesage/docker-nginx-proxy-manager using default ports
# https://github.com/jlesage/docker-nginx-proxy-manager
#

# Pull base image.
FROM  jlesage/nginx-proxy-manager:latest

    # Change the management interface port 8181 to the unprivileged port 81.
RUN sed-patch 's|8181 default|81 default|' /etc/nginx/conf.d/production.conf

    # Change the HTTP port 80 to the unprivileged port 8080.
RUN sed-patch 's|8080;|80;|' /etc/nginx/conf.d/default.conf  \
    && sed-patch 's|"8080";|"80";|' /etc/nginx/conf.d/default.conf  \
    && sed-patch 's|listen 8080;|listen 80;|' /opt/nginx-proxy-manager/templates/letsencrypt-request.conf  \
    && sed-patch 's|listen 8080;|listen 80;|' /opt/nginx-proxy-manager/templates/_listen.conf  \
    && sed-patch 's|:8080;|:80;|' /opt/nginx-proxy-manager/templates/_listen.conf  \
    && sed-patch 's|listen 8080 |listen 80 |' /opt/nginx-proxy-manager/templates/default.conf

    # Change the HTTPs port 4443 to the unprivileged port 443.
RUN sed-patch 's|4443 |443 |' /etc/nginx/conf.d/default.conf  \
    && sed-patch 's|"4443";|"443";|' /etc/nginx/conf.d/default.conf  \
    && sed-patch 's|listen 4443 |listen 443 |' /opt/nginx-proxy-manager/templates/_listen.conf  \
    && sed-patch 's|:4443;|:443;|' /opt/nginx-proxy-manager/templates/_listen.conf

# change nginx run as root, we want expose 80 443 81 port.
RUN sed-patch 's|#user root;|user root;|' /etc/nginx/nginx.conf && \
    chown  root /usr/sbin/nginx && \
    chmod u+s /usr/sbin/nginx
	
# Define mountable directories.
VOLUME ["/config"]

# Expose ports.
#   - 80: HTTP traffic
#   - 443: HTTPs traffic
#   - 81: Management web interface
EXPOSE 80 443 81
