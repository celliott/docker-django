FROM ubuntu:14.04
MAINTAINER chris elliott <ctelliott@gmail.com>

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  python \
  python-dev \ 
  python-setuptools \
  python-pip \
  supervisor

# stop supervisor service as we'll run it manually
RUN service supervisor stop

# build dependencies for postgres and image bindings
RUN apt-get build-dep -y python-imaging python-psycopg2

# install virtualenv
RUN pip install \
  virtualenv \
  virtualenvwrapper

# create a virtual environment and install all dependencies from pypi
RUN virtualenv /opt/venv
ADD ./build /opt/app
ADD ./build/requirements.txt /opt/venv/requirements.txt
RUN /opt/venv/bin/pip install -r /opt/venv/requirements.txt

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# expose port(s)
EXPOSE 5000

#CMD /bin/bash -l
CMD ["/usr/bin/supervisord"]
