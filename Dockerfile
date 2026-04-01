FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release --base-href="/" --no-tree-shake-icons

FROM nginx:alpine AS runtime

COPY --from=build /app/build/web /usr/share/nginx/html
COPY web/otel.js /usr/share/nginx/html/otel.js
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
