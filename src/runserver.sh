#!/bin/bash

current_dir=`dirname $0`
if [ $current_dir == "." ];then
    current_dir=`pwd`
fi
cd ${current_dir}
echo "定向到工作目录: ${current_dir}"

# 网络配置
docker network ls | grep game
if [ $? -ne 0 ];then
    echo "网络模块不存在 创建网络模块"
    docker network create game
fi

# 服务启动
docker ps|grep game-report
if [ $? -ne 0 ];then
    docker run --name game-report -v ${current_dir}/1-report/conf:/etc/nginx/conf.d -p 8082:80 -d game-report:latest
    docker network connect game game-report
fi

docker ps|grep game-mq
if [ $? -ne 0 ];then #其中61613为stomp协议的端口 lua的请求都要发到这边
    docker run -p 61613:61613 -p 5672:5672 -p 15672:15672 --name game-mq -d game-mq:latest
    docker network connect game game-mq
    # 消息队列的初始化
    ./2-rabbitmq/init.sh
fi

docker ps|grep game-log
if [ $? -ne 0 ];then
    docker run --name game-log -v ${current_dir}/3-loghandler/log:/go/src/app/log -d game-log:latest
    docker network connect game game-log
fi

