# WordPress Environment Setup

This repository contains a Docker-based WordPress environment setup.

## TODO

Remove Caddy if automatic https is not required

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
define( 'DB_NAME', getenv('MYSQL_DATABASE') );

/** Database username */
define( 'DB_USER', getenv('MYSQL_USER') );

/** Database password */
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') );

/** Database hostname */
define( 'DB_HOST', getenv('MYSQL_HOST') );
```

8. Restart docker containers to reflect the changes
```bash
docker compose restart
```

9. Create an admin user
```bash
docker exec -it wp-db-1 mysql -uwordpress -p"wordpresspasswordchangeme"
```

```sql
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

## TODO
1. Move admin user creation to `import-db.sh`; read username, email and password from .env.
2. Remove Caddy if https is not required.
3. Fix permission for file creation in `wp-content/uploads`. Until permission is fixed, use this:
```
sudo chmod 777 wp-content/uploads
sudo apt install acl
setfacl -d -m u::rwx,g::rwx,o::rwx wp-content/uploads
setfacl -m u::rwx,g::rwx,o::rwx wp-content/uploads
setfacl -d -m u::rwx,g::rwx,o::rwx wp-content/uploads/2025
setfacl -m u::rwx,g::rwx,o::rwx wp-content/uploads/2025
```