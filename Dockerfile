FROM ubuntu:trusty
RUN apt-get update

RUN apt-get install -y build-essential git
RUN apt-get install -y python python-dev python-setuptools python-pip sqlite3
RUN apt-get install -y nginx supervisor
RUN apt-get install -y libffi-dev libxml2-dev libxslt1-dev libtiff4-dev \
						libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev \
						libwebp-dev
RUN rm -rf /var/lib/apt/lists/*

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

# install uwsgi now because it takes a little while
RUN pip install uwsgi

RUN pip install django Pillow

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# pacotes vem antes pois demoram para instalar
ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install -r requirements.txt

ONBUILD COPY nginx-app.conf /etc/nginx/sites-enabled/
ONBUILD COPY supervisor-app.conf /etc/supervisor/conf.d/

ONBUILD COPY ./api /usr/src/app

#EXPOSE 80
#CMD ["supervisord", "-n"]
