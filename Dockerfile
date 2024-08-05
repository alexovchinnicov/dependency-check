FROM owasp/dependency-check

LABEL Description="Custom OWASP dependency-check image with pre-downloaded bases"

USER root

RUN /usr/share/dependency-check/bin/dependency-check.sh --updateonly
