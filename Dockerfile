FROM centos:7

MAINTAINER gergokee

LABEL Remarks="This is a dockerfile example for puppeteer on Centos 6"

#login as root to perform yum
USER root
RUN yum -y update && \

##We don't need apache:
##yum -y install httpd && \

yum clean all

RUN yum -y install sudo
RUN yum -y install wget
RUN yum -y install gcc-c++ make
RUN curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -
RUN yum -y install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
RUN yum -y install yarn

# Install puppeteer
RUN npm i puppeteer

# If running Docker >= 1.13.0 use docker run's --init arg to reap zombie processes, otherwise
# uncomment the following lines to have `dumb-init` as PID 1
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

#Install missing Chromium dependencies:
RUN yum -y install pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 ipa-gothic-fonts xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic xorg-x11-fonts-Type1 xorg-x11-fonts-misc
RUN npm -y install --save puppeteer

#chrome-sandbox hack:
#RUN cd /node_modules/puppeteer/.local-chromium/linux-*/chrome-linux && mv chrome_sandbox chrome-sandbox && chown root chrome-sandbox && chmod 4755 chrome-sandbox


ENV NODE_PATH="/usr/lib/node_modules:${NODE_PATH}"
ENV PATH="/tools:${PATH}"


RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser

COPY ./tools /tools

# Set language to UTF8
ENV LANG="C.UTF-8"

WORKDIR /app

# Add user so we don't need --no-sandbox.
RUN mkdir /screenshots \
	&& mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /usr/lib/node_modules \
    && chown -R pptruser:pptruser /screenshots \
    && chown -R pptruser:pptruser /app \
    && chown -R pptruser:pptruser /tools

# Run everything after as non-privileged user, for security reasons !!!
USER pptruser

# --cap-add=SYS_ADMIN
# https://docs.docker.com/engine/reference/run/#additional-groups

ENTRYPOINT ["dumb-init", "--"]



CMD ["node", "index.js"]

