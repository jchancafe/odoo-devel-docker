FROM ubuntu:18.04

ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get upgrade -y

RUN apt-get install -y openssh-server fail2ban

#RUN adduser --system --home=/opt/odoo --group odoo
RUN adduser --disabled-password --gecos "Odoo" odoo

RUN apt-get install -y python3-pip

RUN apt-get install -y npm \
    && npm install -g less less-plugin-clean-css \
	&& apt-get install -y node-less \
	&& apt-get install -y nano

RUN pip3 install setuptools==58.0.0

RUN apt-get install -y python3-dev python3-pip libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev libpq-dev libjpeg-dev poppler-utils node-less node-clean-css python3-daemonize

RUN apt-get update && \
        apt install -y --no-install-recommends \
        curl \
        python3-venv \
        python3-wheel \
        libjpeg8-dev \
        liblcms2-dev \
        zlib1g-dev \
        build-essential \
        libssl-dev \
        libffi-dev  \
        libmysqlclient-dev  \
        libblas-dev  \
        libatlas-base-dev  \
        libssl1.1 \
        pkg-config  \
        libxmlsec1-dev \
        libxmlsec1-openssl \
        xmlsec1 \
        python3-pysimplesoap

RUN apt-get install -y wget gdebi-core

RUN pip3 install Babel decorator docutils ebaysdk feedparser gevent greenlet html2text Jinja2 lxml==4.3.2 Mako MarkupSafe mock num2words ofxparse passlib Pillow psutil psycogreen psycopg2 pydot pyparsing PyPDF2 pyserial python-dateutil python-openid pytz pyusb PyYAML qrcode reportlab requests six suds-jurko vatnumber vobject Werkzeug XlsxWriter xlwt xlrd gdata
# Instalando dependencias para facturacion electronica
RUN pip3 install libsass==0.12.3 phonenumbers beautifulsoup4==4.7.1 olefile==0.46 pbr==5.1.3 pdf417gen==0.7.0 py-dateutil==2.2 PySimpleSOAP==1.16.2 python-barcode==0.9.0 python-stdnum==1.11 PyYAML==3.12 query-string==2018.11.20 simplejson==3.16.0 six==1.12.0 soupsieve==1.9 urllib3==1.24.1 genshi
RUN pip3 install beautifulsoup4==4.7.1 xmlsec==1.3.12 lxml-html-clean
#  bravado-core
RUN apt-get install default-jre -y

# Instalar herramientas y dependencias de aeroolib
#RUN apt-get install python3-setuptools python3-uno -y
RUN apt-get install python3-uno -y
#RUN apt-get install python3-lxml -y
RUN apt-get install git -y
RUN pip3 install jsonrpc2

RUN mkdir /opt/aeroo
WORKDIR /opt/aeroo 
RUN git clone https://github.com/aeroo/aeroo_docs.git
RUN yes | python3 /opt/aeroo/aeroo_docs/aeroo-docs start -c /etc/aeroo-docs.conf
RUN ln -s /opt/aeroo/aeroo_docs/aeroo-docs /etc/init.d/aeroo-docs
RUN update-rc.d aeroo-docs defaults
RUN service aeroo-docs start
#RUN service aeroo-docs restart

RUN apt-get install libreoffice libreoffice-script-provider-python -y
RUN echo '#!/bin/sh' | tee /etc/init.d/office
RUN echo '/usr/bin/libreoffice --headless --accept="socket,host=localhost,port=8100,tcpNoDelay=1;urp;"&' | tee -a /etc/init.d/office
RUN chmod +x /etc/init.d/office
RUN update-rc.d office defaults
RUN /etc/init.d/office

RUN apt install unoconv -y

WORKDIR /opt/odoo

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb

RUN apt install -y ./wkhtmltox_0.12.5-1.bionic_amd64.deb

RUN apt-get update

RUN apt-get install -y postgresql-client
