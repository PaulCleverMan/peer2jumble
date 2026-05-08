# =========================================================
# Tools (no systemd)
# =========================================================

uv_dep() {
  define_dep \
  tool \
  "uv" \
  "uv" \
  "" \
  "https://docs.astral.sh/uv/getting-started/installation/" \
  1
}

# =========================================================
# Services (systemd)
# =========================================================

docker_dep() {
  define_dep \
  service \
  "Docker" \
  "docker" \
  "docker.service" \
  "https://docs.docker.com/engine/install/" \
  1
}

postgres_dep() {
  define_dep \
  service \
  "PostgreSQL" \
  "psql" \
  "postgresql.service" \
  "https://www.postgresql.org/download/" \
  1
}

redis_dep() {
  define_dep \
  service \
  "Redis" \
  "redis-server" \
  "redis-server.service" \
  "https://redis.io/docs/latest/operate/oss_and_stack/install/archive/install-redis/" \
  1
}

rabbitmq_dep() {
  define_dep \
  service \
  "RabbitMQ" \
  "rabbitmqctl" \
  "rabbitmq-server.service" \
  "https://www.rabbitmq.com/download.html" \
  1
}

nginx_dep() {
  define_dep \
  service \
  "Nginx" \
  "nginx" \
  "nginx.service" \
  "https://nginx.org/en/download.html" \
  0
}