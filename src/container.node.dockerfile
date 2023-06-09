FROM kjmoraji/nodebase:latest

COPY ./tessera_installation.sh /app/tessera_installation.sh
COPY ./tessera_configuration.sh /app/tessera_configuration.sh

RUN chmod +x /app/tessera_installation.sh
RUN ./app/tessera_installation.sh

COPY ./quorum_installation.sh /app/quorum_installation.sh
COPY ./quorum_configuration.sh /app/quorum_configuration.sh

RUN chmod +x /app/quorum_installation.sh
RUN ./app/quorum_installation.sh

COPY ./run.sh /app/run.sh