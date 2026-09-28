#!/usr/bin/env bash
# Requires compose() from compose.sh.
print_service_urls() {
  local running service port label path binding host published url
  running=$(compose ps --status running --services)
  echo "Service URLs (open on the Docker host):"
  while IFS='|' read -r service port label path; do
    if [[ $'\n'"$running"$'\n' != *$'\n'"$service"$'\n'* ]]; then
      printf '  %-18s %s\n' "$label" "not running"
      continue
    fi
    binding=$(compose port "$service" "$port")
    binding=${binding%%$'\n'*}
    if [[ -z "$binding" ]]; then
      printf '  %-18s %s\n' "$label" "port is not published"
      continue
    fi
    host=${binding%:*}
    published=${binding##*:}
    case "$host" in
      0.0.0.0|'[::]'|'::') host=localhost ;;
    esac
    url="http://$host:$published$path"
    printf '  %-18s %s\n' "$label" "$url"
  done <<'SERVICES'
web|8000|Web (base URL)|/
web|8000|Django admin|/admin/
web|8000|Health (stub)|/monitoring/health/
flower|5555|Celery / Flower|/
rabbitmq|15672|RabbitMQ UI|/
SERVICES
}
