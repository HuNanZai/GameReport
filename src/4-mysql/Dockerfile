FROM mysql

ENV MYSQL_DATABASE game
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

COPY ./sqls/ /docker-entrypoint-initdb.d/