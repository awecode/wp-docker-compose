docker exec -i $(docker compose ps -q db) mysql -u root -prootpasswordchangeme -e "DROP DATABASE IF EXISTS wordpress; CREATE DATABASE wordpress;"
docker exec -i $(docker compose ps -q db) mysql -u wordpress -pwordpresspasswordchangeme wordpress < dump.sql
docker exec -i $(docker compose ps -q db) mysql -u wordpress -pwordpresspasswordchangeme wordpress -e "UPDATE wp_options SET option_value='http://localhost:8080' WHERE option_name='siteurl' OR option_name='home';"
