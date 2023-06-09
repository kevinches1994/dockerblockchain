FROM kjmoraji/nodebase:latest

COPY ./quorum_installation.sh /app/quorum_installation.sh
COPY ./quorum_configuration.sh /app/quorum_configuration.sh

RUN chmod +x /app/quorum_installation.sh
RUN ./app/quorum_installation.sh