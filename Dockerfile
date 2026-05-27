FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    curl \
    gnupg \
    gcc \
    g++

RUN pip install pymssql pyodbc sqlalchemy gunicorn

USER superset

CMD ["/bin/bash", "-c", "\
superset db upgrade && \
superset init && \
gunicorn -w 2 -b 0.0.0.0:8088 'superset.app:create_app()'"]