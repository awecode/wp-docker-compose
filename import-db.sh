#!/bin/bash

# Set up logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting WordPress database initialization script"

# Load environment variables from .env
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | sed 's/\r$//' | xargs)
    log "Successfully loaded environment variables from .env"
else
    log "ERROR: .env file not found"
    exit 1
fi

# Drop and recreate database
log "Dropping and recreating database '${MYSQL_DATABASE}'"
if docker exec -i $(docker compose ps -q db) mysql -u root -p${MYSQL_ROOT_PASSWORD} \
    -e "DROP DATABASE IF EXISTS ${MYSQL_DATABASE}; CREATE DATABASE ${MYSQL_DATABASE};"; then
    log "Successfully recreated database"
else
    log "ERROR: Failed to recreate database"
    exit 1
fi

# Import database dump
log "Importing database dump from dump.sql"
if docker exec -i $(docker compose ps -q db) mysql \
    -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < dump.sql; then
    log "Successfully imported database dump"
else
    log "ERROR: Failed to import database dump"
    exit 1
fi

# Update WordPress URLs
log "Updating WordPress URLs to ${BASE_URL}"
if docker exec -i $(docker compose ps -q db) mysql \
    -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} \
    -e "UPDATE wp_options SET option_value='${BASE_URL}' WHERE option_name='siteurl' OR option_name='home';"; then
    log "Successfully updated WordPress URLs"
else
    log "ERROR: Failed to update WordPress URLs"
    exit 1
fi

log "WordPress database initialization completed successfully"
