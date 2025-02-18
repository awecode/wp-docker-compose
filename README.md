# WordPress Environment Setup

This repository contains a Docker-based WordPress environment setup.

## Prerequisites

- Docker and Docker Compose installed on your system
- Basic understanding of WordPress, Docker, and MySQL/MariaDB

## Setup Instructions

1. Clone this repository:

```bash
git clone https://github.com/awecode/wp-docker-compose wp
cd wp
```

2. Copy the `.env.example` file to `.env` and configure the environment variables:

```bash
cp .env.example .env
```

3. Copy or clone your wordpress project to the `app` folder.

4. If you have a database dump, place it in the `wp` folder and name it `dump.sql`.

5. Initialize the services (required for db import):

```bash
docker compose up -d
```

6. To import the database, run the import script:

```bash
./import-db.sh
```






