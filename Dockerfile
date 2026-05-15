FROM perl:5.40-slim AS test
WORKDIR /app
COPY lib ./lib
COPY t ./t
COPY bin ./bin
RUN perl -c bin/stakeholder.pl
RUN prove -Ilib t

FROM perl:5.40-slim
WORKDIR /app
COPY lib ./lib
COPY bin ./bin
ENTRYPOINT ["perl", "-Ilib", "bin/stakeholder.pl"]
