FROM maven:amazoncorretto

LABEL Description="Custom OWASP dependency-check image with pre-downloaded bases"

RUN mvn org.owasp:dependency-check-maven:update-only -DdataDirectory=/owasp && \
    rm -rf /root/.m2/
