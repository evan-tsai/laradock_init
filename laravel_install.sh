#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'

echo Enter Git Path
read gitpath

git clone $gitpath

gitname=$(echo "$gitpath" | rev | cut -d'/' -f 1 | rev)
project=${gitname%.*}

cp laradock/apache2/sites/sample.conf.example laradock/apache2/sites/$project.conf
sed -i '' "s/sample\/public\//$project\//g" laradock/apache2/sites/$project.conf
sed -i '' "s/sample.test/$project.test/g" laradock/apache2/sites/$project.conf

cd laradock
docker-compose exec mysql sh -c 'mysql -u root -proot -e "create database if not exists \`'$project'\`;"'

docker exec -it --user=laradock laradock_workspace_1 bash --login -c "cd $project && 
composer install && 
yarn && 
ln -s ../storage/app/public public/storage && 
cp .env.example .env && 
sed -i 's/APP_URL=/APP_URL=http:\/\/$project.test/g' .env && 
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' .env && 
sed -i 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env && 
sed -i 's/DB_PASSWORD=homestead/DB_PASSWORD=root/g' .env && 
sed -i 's/DB_DATABASE=default/DB_DATABASE=$project/g' .env && 
php artisan key:generate"

docker exec -it --user=root laradock_workspace_1 bash --login -c 'cd '$project' &&
echo "Seed Database?" &&
select yn in "Yes" "No"; do
     case $yn in
         Yes ) 
			php artisan migrate --seed
		break;;
        No ) break;;
    esac
done'

docker-compose restart apache2
