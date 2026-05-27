FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    curl \
    gnupg \
    gcc \
    g++ \
    libgssapi-krb5-2 \
    libssl-dev

# Python DB drivers (no msodbcsql18)
RUN pip install pymssql pyodbc sqlalchemy

USER superset

CMD ["/bin/bash", "-c", "\
superset db upgrade && \
superset init && \
gunicorn -w 2 -k gevent --timeout 120 -b 0.0.0.0:8088 'superset.app:create_app()'"]