# adomenech Base image is a ubuntu
#
# VERSION               0.0.1

FROM      adomenech73/base
MAINTAINER Albert Domenech <adomenech@gmail.com>

RUN apt-get update && apt-get install -y \
  python-cairo \
  libgcrypt11 \
  python-virtualenv \
  build-essential \
  python-dev \
  sudo && \
  adduser --system --home /opt/graphite graphite && \
  sudo -u graphite virtualenv --system-site-packages ~graphite/env && \
  echo "django >=1.3.7,<1.4 \n \
  python-memcached \n \
  django-tagging==0.3.1 \n \
  twisted==11.1.0 \n \
  gunicorn \n \
  whisper==0.9.12 \n \
  carbon==0.9.12 \n \
  graphite-web==0.9.12" > /tmp/graphite_reqs.txt && \
  sudo -u graphite HOME=/opt/graphite /bin/sh -c ". ~/env/bin/activate && pip install -r /tmp/graphite_reqs.txt"

  ADD graphite/local_settings.py /opt/graphite/webapp/graphite/
  ADD graphite/wsgi.py /opt/graphite/webapp/graphite/
  ADD graphite/mkadmin.py /opt/graphite/webapp/graphite/
  ADD graphite/carbon.conf /opt/graphite/conf/
  ADD graphite/storage-schemas.conf /opt/graphite/conf/
  ADD graphite/storage-aggregation.conf /opt/graphite/conf/
  ADD graphite/graphTemplates.conf /opt/graphite/conf/

  RUN sed -i "s#^\(SECRET_KEY = \).*#\1\"`python -c 'import os; import base64; print(base64.b64encode(os.urandom(40)))'`\"#" /opt/graphite/webapp/graphite/app_settings.py && \
      sudo -u graphite HOME=/opt/graphite PYTHONPATH=/opt/graphite/lib/ /bin/sh -c "cd ~/webapp/graphite && ~/env/bin/python manage.py syncdb --noinput" && \
      sudo -u graphite HOME=/opt/graphite PYTHONPATH=/opt/graphite/lib/ /bin/sh -c "cd ~/webapp/graphite && ~/env/bin/python mkadmin.py"

  CMD exec supervisord -n

  # gunicorn, * , Carbon line receiver port, Carbon pickle receiver port, Carbon cache query port
  EXPOSE 8080 25826/udp 2030 2040 7002
