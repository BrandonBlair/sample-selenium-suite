FROM python3

RUN apt-get update \
    && apt-get install -y \
        wget \
        gnupg \
        chromedriver \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /usr/share/locale/* \
    && rm -rf /var/cache/debconf/*-old \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc/*

# Download and install Chrome.
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y \
        google-chrome-stable

# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 2.33
ENV CHROMEDRIVER_DIR /chromedriver
ENV PATH $CHROMEDRIVER_DIR:$PATH

# replace org name here
ENV WRKDIR /opt/myorg/automated_testing/
WORKDIR $WRKDIR

COPY . $WRKDIR

ENTRYPOINT ["python -m pytest"]
# CMD ["--markers"]
