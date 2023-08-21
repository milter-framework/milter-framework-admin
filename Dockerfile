FROM python:3.10-alpine as builder

ARG PIP_MYSQLCLIENT_VERSION=2.1.1

RUN apk update
RUN apk add mysql-dev gcc libc-dev

RUN pip install -t "/build/mysqlclient" "mysqlclient==${PIP_MYSQLCLIENT_VERSION}"


FROM python:3.10-alpine

ARG APP_VERSION=0.0.0
ENV PYTHONPATH=/mysqlclient:${PYTHONPATH}

LABEL org.opencontainers.image.title="milter-framework-admin"
LABEL org.opencontainers.image.description="Milter Framework Admin"
LABEL org.opencontainers.image.authors="Pavel Kim <hello@pavelkim.com>"
LABEL org.opencontainers.image.version="${APP_VERSION}"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

WORKDIR /app

RUN apk add --update --no-cache mariadb-connector-c

COPY --from=builder /build/mysqlclient /mysqlclient
COPY ./entrypoint.sh .
COPY ./.version .
COPY ./gunicorn.conf.py.example ./gunicorn.conf.py

RUN ls -laR

COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./milter-framework-admin .

ENTRYPOINT [ "/app/entrypoint.sh" ]
