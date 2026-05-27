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
(superset fab create-admin --username credx1234 --firstname credx1234 --lastname credx1234 --email admin@test.com --password credx1234 || true) && \
gunicorn -w 2 -b 0.0.0.0:$PORT 'superset.app:create_app()'"]