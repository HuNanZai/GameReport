FROM rabbitmq:3

# 安装stomp协议支持 lua采用stomp协议请求rabbitmq
RUN rabbitmq-plugins enable --offline rabbitmq_stomp rabbitmq_management rabbitmq_web_stomp

# 复制管理命令
COPY rabbitmqadmin /opt/rabbitmq/sbin