#/bin/bash
set -e

DIR="( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/home/quincey/data}

killz(){
    echo "Killing all docker containers:"
    docker ps
    ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
    echo $ids | xargs docker kill
    echo $ids | xargs docker rm
}

stop(){
    echo "Stopping all docker containers:"
    docker ps -a
    ids=`docker ps -a | tail -n +2 |cut -d ' ' -f 1`
    echo $ids | xargs docker stop
    echo $ids | xargs docker rm
}

start(){
    # MongoDB
    mkdir -p $APPS/mongo/data
    mkdir -p $APPS/mongo/logs
    MONGO=$(docker run \
        -p 27017:27017 \
        -p 28017:28017 \
        -v $APPS/mongo/data:/data/mongo \
        -v $APPS/mongo/logs:/logs \
        -d \
        mongo)
    echo "Started MONGO in container $MONGO"

    # Apache & PHP
    chcon -R -t httpd_sys_content_t "/home/quincey/projects/qkroode.nl"
    WEBSERVER=$(docker run \
        -p 80:80 \
        -v /home/quincey/projects/qkroode.nl:/app \
        -d \
        kbrs/apache-php)
    echo "Started WEBSERVER in container $WEBSERVER"

    chown -R quincey:quincey $APPS
    sleep 1
}

update(){
    yum update -y
}

case "$1" in
    restart)
        killz
        start
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    kill)
        killz
        ;;
    update)
        update
        ;;
    status)
        docker ps
        ;;
    *)
        echo $"Usage: $0 {start|stop|kill|update|restart|status}"
        RETVAL=1
esac
