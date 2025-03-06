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

7. Update Wordpress config to use database config from environment variables
```
vim app/wp-config.php
```

```php
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') );

/** Database username */
define( 'DB_USER', getenv('WORDPRESS_DB_USER') );

/** Database password */
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') );

/** Database hostname */
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') );
```

8. Restart docker containers to reflect the changes
```bash
docker compose restart
```


9. If there is a redirect loop because Wordpress still thinks it is not on https, force Wordpress to infer that it is https
```
vim app/wp-config.php
```

```php
if (
    isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
    $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https'
) {
    $_SERVER['HTTPS'] = 'on';
}
```

10. Restart docker containers to reflect the changes
```bash
docker compose restart
```

11. Create an admin user
```
docker exec -it wp-db-1 mysql -uwordpress -p"wordpresspasswordchangeme"
```
USE wordpress;

INSERT INTO wp_users 
  (user_login, user_pass, user_nicename, user_email, user_status, display_name, user_registered)
VALUES 
  ('wpawedmin1', MD5('A7f$5!zR8@dC3qL2'), 'wpawedmin1', 'reach+wpawedmin1@awecode.com', 0, 'wpawedmin1', NOW());

INSERT INTO wp_usermeta 
  (user_id, meta_key, meta_value)
VALUES 
  (LAST_INSERT_ID(), 'wp_capabilities', 'a:1:{s:13:"administrator";b:1;}');

INSERT INTO wp_usermeta 
  (user_id, meta_key, meta_value)
VALUES 
  (LAST_INSERT_ID(), 'wp_user_level', '10');
```