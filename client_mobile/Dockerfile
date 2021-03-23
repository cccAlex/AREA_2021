FROM cirrusci/flutter

COPY . /app
WORKDIR /app

USER root

RUN rm -f .packages

RUN flutter pub get
RUN flutter clean
RUN flutter build apk --split-per-abi

CMD ["cp", "build/app/outputs/flutter-apk/app.apk", "/var/client/client.apk"]