FROM debian-web2py:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    python-pip

WORKDIR /var/www/web2py/applications

RUN git clone -q https://github.com/bnmnetp/runestone.git
RUN chown -R www-data runestone/

WORKDIR /var/www/web2py/applications/runestone

RUN apt-get install -y --no-install-recommends \
    python-jinja2 \
    python-markupsafe \
    python-paver \
    python-pygments \
    python-sphinx \
    python-astroid \
    python-diff-match-patch \
    python-docutils \
    python-logilab-common \
    python-lxml \
    python-psycopg2
    
RUN sed -i 's/^/#/g' requirements.txt
RUN sed -i 's/^#sphinxcontrib/sphinxcontrib/g' requirements.txt
RUN sed -i 's/^#cogapp/cogapp/g' requirements.txt
RUN pip install -r requirements.txt

RUN echo "master_url = 'https://localhost:8443'" > paverconfig.py
RUN echo "master_app = 'runestone'" >> paverconfig.py
RUN echo "minify_js = False" >> paverconfig.py

RUN paver allbooks

WORKDIR /var/www/web2py/

RUN cp examples/routes.patterns.example.py routes.py
RUN sed -i "s/default_application = 'init'/default_application = 'runestone'/g" routes.py
RUN sed -i "s/r'myapp'/r'runestone'/g" routes.py

RUN rm -fr /var/www/web2py/applications/welcome
RUN rm -fr /var/www/web2py/applications/examples

EXPOSE 80
EXPOSE 443

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

