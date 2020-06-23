#!/bin/bash
#该脚本主要进行消息队列的初始化工作
docker_name='game-mq'
# 获取docker示例id
docker_id=`docker ps |grep ${docker_name}|awk '{print $1}'`

# 初始化账号
docker exec -it ${docker_id} rabbitmqctl add_user game game
docker exec -it ${docker_id} rabbitmqctl set_permissions --vhost / game '.*' '.*' '.*' 

# 初始化exchange queue binding
# wget http://localhost:15672/cli/rabbitmqadmin
current_dir=`dirname $0`
cd ${current_dir}

chmod +x rabbitmqadmin

./rabbitmqadmin declare exchange --vhost=/ name=game_exchange type=direct
./rabbitmqadmin declare queue --vhost=/ name=game_queue durable=true
./rabbitmqadmin --vhost="/" declare binding source="game_exchange" destination_type="queue" destination="game_queue" routing_key="game"
