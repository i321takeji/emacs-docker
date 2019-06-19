FROM bamboog130/emacs:build-26.2 as emacs-dev

FROM ubuntu:18.04

LABEL maintainer "bamboog130"

ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive

# change apt source
RUN sed -i.bak -e "s%http://.*.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list \
&& apt-get update && apt-get install -y --no-install-recommends \
  emacs-mozc-bin \
  fonts-ricty-diminished \
  libgif7 \
  libgtk2.0-0 \
  libpng16-16 \
  libsm6 \
  libtiff5 \
  libxft2 \
  libxpm4 \
  libxt6 \
  ssh \
  sshpass \
&& apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

COPY --from=emacs-dev /tmp/installed-emacs /usr/local/

COPY res/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY res/init_emacs.sh /usr/local/bin/init_emacs.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /work-dir

ENV EMACS_USER emacser
ENV EMACS_UID 99999
ENV EMACS_GID 99999

ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
