# ---------- build stage ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY app/package*.json ./

RUN npm install --legacy-peer-deps

COPY app/ .

RUN npm run build

# ---------- runtime stage ----------
FROM nginx:stable-alpine

# Install certificates + create non-root user
RUN apk add --no-cache ca-certificates && \
    addgroup -S appgroup && \
    adduser -S nonrootuser -G appgroup

RUN rm /etc/nginx/conf.d/default.conf

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html

RUN chown -R nonrootuser:appgroup /usr/share/nginx/html \
    /var/cache/nginx \
    /var/run \
    /etc/nginx

USER nonrootuser

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]