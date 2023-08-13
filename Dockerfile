FROM j4n11s/base-vnc

LABEL org.opencontainers.image.authors="janis@js0.ch"
LABEL org.opencontainers.image.source="https://github.com/saschazesiger/"

ENV URL=https://browser.lol/redirect-url-to

COPY /scripts /opt/scripts

RUN apt-get update && \
	apt-get -y install --no-install-recommends fonts-takao fonts-arphic-uming libgtk-3-0 libgconf-2-4 libnss3 fonts-liberation libasound2 libcurl3-gnutls libcurl3-nss libcurl4 libgbm1 libnspr4 libnss3 libu2f-udev xdg-utils

RUN wget -q -nc --show-progress --progress=bar:force:noscroll -O /tmp/opera.deb "https://download.opera.com/download/get/?id=62544&location=415&nothanks=yes&sub=marine&utm_tryagain=yes"
RUN dpkg -i /tmp/opera.deb || apt-get install -yf
RUN rm /tmp/opera.deb

#Server Start
CMD ["bash", "/opt/scripts/start.sh"]
