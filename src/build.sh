#!/bin/bash

function build()
{
    echo "get image name: $1"
    if [ $1 == "" ];then
        echo "参数错误!"
        exit 1
    fi
    image=`docker image ls|grep $1`
    if [ "${image}" == "" ];then
        echo "镜像$1: 不存在 开始构建"
        docker build ./ -t $1
        if [ $? -eq 0 ];then
            echo "镜像$1: 构建成功"
        else
            echo "镜像$1: 构建失败"
        fi
    else
        echo "镜像$1: 已经存在 跳过构建"
    fi
}

cd ./1-report
build "game-report"

cd ../2-rabbitmq
build "game-mq"

cd ../3-loghandler
build "game-log"

