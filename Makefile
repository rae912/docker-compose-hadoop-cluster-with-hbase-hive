DOCKER_NETWORK = hbase
ENV_FILE = hadoop.env
# current_branch := $(shell git rev-parse --abbrev-ref HEAD)
current_branch := 1.0.0-hbase1.6.0
hadoop_branch := 2.0.0-hadoop2.7.4-java8
build:
	docker build -t bde2020/hbase-base:$(current_branch) ./base
	docker build -t bde2020/hbase-master:$(current_branch) ./hmaster
	docker build -t bde2020/hbase-regionserver:$(current_branch) ./hregionserver
	docker build -t bde2020/hbase-standalone:$(current_branch) ./standalone

up: build
	docker-compose up -d

start: up jars2hive
	echo 'hadoop / hive / hbase cluster started!'

wordcount:
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(hadoop_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(hadoop_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-2.7.4/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(hadoop_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(hadoop_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(hadoop_branch) hdfs dfs -rm -r /input

jars2hive:
	docker cp hbase-master:/opt/hbase-1.6.0/lib/hbase-client-1.6.0.jar ./jars && \
    docker cp hbase-master:/opt/hbase-1.6.0/lib/hbase-hadoop-compat-1.6.0.jar ./jars && \
    docker cp hbase-master:/opt/hbase-1.6.0/lib/hbase-hadoop2-compat-1.6.0.jar ./jars && \
    docker cp hbase-master:/opt/hbase-1.6.0/lib/hbase-it-1.6.0.jar ./jars && \
    docker cp hbase-master:/opt/hbase-1.6.0/lib/hbase-server-1.6.0.jar ./jars && \
    docker cp ./jars/hbase-client-1.6.0.jar hive-server:/opt/hive/lib/ && \
    docker cp ./jars/hbase-hadoop-compat-1.6.0.jar hive-server:/opt/hive/lib/ && \
    docker cp ./jars/hbase-hadoop2-compat-1.6.0.jar hive-server:/opt/hive/lib/ && \
    docker cp ./jars/hbase-it-1.6.0.jar hive-server:/opt/hive/lib/ && \
    docker cp ./jars/hbase-server-1.6.0.jar hive-server:/opt/hive/lib/
