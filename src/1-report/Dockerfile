FROM openresty/openresty:latest

# 定义依赖的mq的链接参数
ARG MQ_HOST=""
ARG MQ_PORT=""
ARG MQ_USER=""
ARG MQ_PASSWD=""

ENV MQ_HOST=${MQ_HOST}
ENV MQ_PORT=${MQ_PORT}
ENV MQ_USER=${MQ_USER}
ENV MQ_PASSWD=${MQ_PASSWD}

COPY ./conf/rabbitmqstomp.lua /usr/local/openresty/lualib/resty/

