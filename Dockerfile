FROM jeremylong/open-vulnerability-data-mirror as downloader

ARG APIKEY

ENV NVD_API_KEY=$APIKEY
ENV DELAY=1000

ADD https://raw.githubusercontent.com/Retirejs/retire.js/master/repository/jsrepository.json /usr/local/apache2/htdocs/jsrepository.json
#ADD https://static.nvd.nist.gov/feeds/xml/cpe/dictionary/official-cpe-dictionary_v2.3.xml.gz /usr/local/apache2/htdocs/official-cpe-dictionary_v2.3.xml.gz
ADD https://jeremylong.github.io/DependencyCheck/suppressions/publishedSuppressions.xml /usr/local/apache2/htdocs/publishedSuppressions.xml
ADD https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json /usr/local/apache2/htdocs/known_exploited_vulnerabilities.json

RUN chmod +r /usr/local/apache2/htdocs/jsrepository.json && \
    chmod +r /usr/local/apache2/htdocs/official-cpe-dictionary_v2.3.xml.gz && \
    chmod +r /usr/local/apache2/htdocs/publishedSuppressions.xml && \
    chmod +r /usr/local/apache2/htdocs/known_exploited_vulnerabilities.json && \
    /mirror.sh



FROM nginx

LABEL Description="Custom OWASP dependency-check mirroring image with pre-downloaded bases"


USER root

RUN mkdir -p /usr/share/nginx/html/ &&\
    echo '<!DOCTYPE html> \
          <html> \
          <head> \
          <title>Image notes</title> \
          <style> \
          html { color-scheme: light dark; } \
          body { width: 35em; margin: 0 auto; font-family: Tahoma, Verdana, Arial, sans-serif; } \
          </style> \
          </head> \
          <body> \
          <h1>Notes.</h1> \
          <p>You should configure dependency-check to use the NVD Datafeed URL for this.</p><br/> \
          <p>A retireJsUrl file name is jsrepository.json.</p> \
          <p>For online documentation please refer to \
          <a href="https://jeremylong.github.io/DependencyCheck/">DependencyCheck documentation</a>.<br/> \
          <p><em>Image has been created at $(date '+%d/%m/%Y %H:%M:%S').</em></p> \
          </body></html>' > /usr/share/nginx/html/index.html 


COPY --from=downloader /usr/local/apache2/htdocs /usr/share/nginx/html
