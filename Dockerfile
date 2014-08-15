FROM debian:jessie

RUN apt-get update -y \
 && apt-get install -y -q wget unzip ruby2.1 ruby2.1-dev patch build-essential xvfb chromium \
 && apt-get -q -y clean \
 && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "Miser" --uid 5001 miser
RUN wget https://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip -O /tmp/chromedriver.zip \
 && unzip /tmp/chromedriver.zip \
 && mv chromedriver /usr/local/bin/ \
 && chmod a+x /usr/local/bin/chromedriver \
 && gem install miser --no-rdoc --no-ri --version=0.0.7

USER miser
CMD ["miser", "interactive"]
