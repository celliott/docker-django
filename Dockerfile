FROM ubuntu:14.04
MAINTAINER MAINTAINER market-bridge dev <dev@market-bridge.com>

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  python \
  python-dev \ 
  python-setuptools \
  python-pip \
  python-virtualenv \
  supervisor

# stop supervisor service as we'll run it manually
RUN service supervisor stop

# build dependencies for postgres and image bindings
RUN apt-get build-dep -y python-imaging python-psycopg2

# create a virtual environment and install all dependencies from pypi
RUN virtualenv /opt/venv
ADD ./build/requirements.txt /opt/venv/requirements.txt
RUN /opt/venv/bin/pip install -r /opt/venv/requirements.txt

# expose port(s)
EXPOSE 80

CMD /bin/bash -l
