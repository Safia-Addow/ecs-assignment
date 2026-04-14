# ---------- build stage ----------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files from app folder
COPY app/package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy rest of app
COPY app/ .

# Build React app
RUN npm run build

# ---------- runtime stage ----------
FROM nginx:stable-alpine

# Install certificates + create non-root user
RUN apk add --no-cache ca-certificates && \
    addgroup -S appgroup && \
    adduser -S nonrootuser -G appgroup

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy nginx config
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built app
COPY --from=builder /app/build /usr/share/nginx/html

# Fix permissions
RUN chown -R nonrootuser:appgroup /usr/share/nginx/html \
    /var/cache/nginx \
    /var/run \
    /etc/nginx

# Run as non-root
USER nonrootuser

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]