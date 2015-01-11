# Docker image containing the Diamond collector
#
# VERSION               0.0.1

FROM      adomenech73/base
MAINTAINER Albert Domenech <adomenech@gmail.com>

RUN apt-get update && apt-get install -y \
  pbuilder \
  python-mock \
  python-configobj \
  python-support \
  python-psycopg2 \
  git \
  cdbs && \
  rm -rf /var/lib/apt/lists/* && \
  git clone https://github.com/BrightcoveOS/Diamond/

WORKDIR /Diamond

RUN make builddeb && \
    sudo dpkg -i build/diamond_*_all.deb

ADD diamond /etc/diamond/
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD exec /usr/bin/diamond  -f
