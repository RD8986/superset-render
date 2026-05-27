FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    curl \
    gnupg

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/debian/11/prod.list \
    > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update

RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18

RUN pip install pymssql pyodbc

USER superset

CMD ["/bin/bash", "-c", "superset db upgrade && superset fab create-admin --username Credx1234 --firstname admin --lastname admin --email admin@test.com --password Credx1234 && superset init && gunicorn -w 2 -k gevent --timeout 120 -b 0.0.0.0:8088 'superset.app:create_app()'"]