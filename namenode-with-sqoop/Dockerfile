FROM bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8

ENV SQOOP_HOME /usr/local/sqoop

RUN curl -s https://ftp.wayne.edu/apache/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz | tar -xz -C /usr/local
RUN ln -s /usr/local/sqoop-1.4.7.bin__hadoop-2.6.0 $SQOOP_HOME

ENV PATH $PATH:$HADOOP_HOME/bin:$SQOOP_HOME/bin

RUN curl -L https://jdbc.postgresql.org/download/postgresql-42.2.18.jar -o postgresql-42.2.18.jar
RUN cp postgresql-42.2.18.jar $SQOOP_HOME/lib

ENV HADOOP_COMMON_HOME /opt/hadoop-2.7.4
ENV HADOOP_MAPRED_HOME /opt/hadoop-2.7.4
RUN which hadoop
RUN ls -al $SQOOP_HOME/lib
RUN sqoop help
