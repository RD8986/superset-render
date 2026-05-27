FROM apache/superset:latest

USER root

# system dependencies
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    curl \
    gnupg \
    gcc \
    g++

# Microsoft ODBC driver repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/debian/11/prod.list \
    > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update

RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Python DB drivers
RUN pip install pymssql pyodbc sqlalchemy

USER superset

# safer startup (NO admin creation here)
CMD ["/bin/bash", "-c", "\
superset db upgrade && \
superset init && \
gunicorn -w 2 -k gevent --timeout 120 -b 0.0.0.0:8088 'superset.app:create_app()'"]