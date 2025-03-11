#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"

zip_files() {
	path=$(pwd)
	cd ../data
	mkdir comp
	echo "COMPRIMINDO arquivos .csv em /data:"
	zip comp/csvs.zip *.csv
	split -b 50m comp/csvs.zip comp/csvs_
	rm comp/csvs.zip
	
	cd ../db
	mkdir comp
	echo "COMPRIMINDO database em /db:"
	zip comp/db.zip *.db
	split -b 50m comp/db.zip comp/db_
	rm comp/db.zip
	
}

unzip_files() {
	path=$(pwd)
	cd ../data
	echo "EXTRAINDO arquivos .csv em /data"
	cat comp/csvs_* > comp/csvs.zip
	unzip comp/csvs.zip
	rm -rf comp
	echo "Extração finalizada."
	
	cd ../db
	echo "EXTRAINDO database em /db"
	cat comp/db_* > comp/db.zip
	unzip comp/db.zip
	rm -rf comp
	echo "Extração finalizada."	
	
}

clean_files() {
	echo "Removendo arquivos comprimidos..."
	rm ../db/workshop.db
	rm ../data/*.csv
}

arg=$1
echo $arg

if [[ $arg == "zip" ]]; then
	zip_files
	clean_files
elif [[ $arg == "unzip" ]]; then
	unzip_files
elif [[ $arg == "clean" ]]; then
	clean_files
else
	echo "Arg. inválido. Encerando."
	exit
fi
