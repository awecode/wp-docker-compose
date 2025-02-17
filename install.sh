docker exec -i $(docker compose ps -q db) mysql -u root -prootpasswordchangeme -e "DROP DATABASE IF EXISTS wordpress; CREATE DATABASE wordpress;"
docker exec -i $(docker compose ps -q db) mysql -u wordpress -pwordpresspasswordchangeme wordpress < dump.sql
