FROM debian:jessie
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd appgroup && \
    useradd -m -d /home/appuser -s /bin/bash -g appgroup appuser && \
    chown -R appuser:appgroup /home/appuser

RUN pip install s3cmd

RUN mkdir /data && \
    chown appuser:appgroup /data

ADD s3cfg /home/appuser/.s3cfg
RUN chown appuser:appgroup /home/appuser/.s3cfg

USER appuser
WORKDIR /home/appuser

RUN mkdir logs

ADD start.sh /home/appuser/start.sh
RUN chmod +x /home/appuser/start.sh

ADD sync.sh /home/appuser/sync.sh
RUN chmod +x /home/appuser/sync.sh

ADD get.sh /home/appuser/get.sh
RUN chmod +x /home/appuser/get.sh

ENTRYPOINT ["/home/appuser/start.sh"]
CMD [""]
