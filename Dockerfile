FROM python:3.7.3-alpine3.10
LABEL maintainer="dou9g@icloud.com"

# allow user and source root to be passed as args. Default to sensibles
ARG app_user=hellominikube
ARG project_root=/app/

# create app dir and non root user
RUN mkdir -p ${project_root} && \
    addgroup -g 1001 ${app_user} && \
    adduser -u 1001 -D ${app_user} -G ${app_user} && \
    chown -R ${app_user}:${app_user} ${project_root}

# set local directory
WORKDIR ${project_root}

# copy and install requirements
COPY ./requirements.txt ${project_root}requirements.txt
RUN pip install --upgrade pip && \
    pip install -r ${project_root}requirements.txt && \
    rm ${project_root}requirements.txt

# change to our non root user for security purposes
USER ${app_user}

# copy code and change log across, expose ports, setup env vars & boot gunicorn
ENV PYTHONUNBUFFERED 1
COPY ./helloworld ${project_root}
COPY ./CHANGELOG.md ${project_root}CHANGELOG.md
EXPOSE 8080
CMD ["gunicorn", "--pythonpath", "/app/helloworld", "--workers", "4", \
    "--access-logfile", "-", "wsgi", "--reload", "-b", "0.0.0.0:8080" ]
