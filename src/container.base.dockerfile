FROM ubuntu:latest

COPY ./setup.sh /app/setup.sh
COPY ./common.sh /app/common.sh

RUN chmod +x /app/setup.sh
RUN ./app/setup.sh

RUN chmod +x /app/common.sh
RUN ./app/common.sh