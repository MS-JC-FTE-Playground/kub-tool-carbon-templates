#!/usr/bin/env sh

mkdir ${PWD}/release

for i in `find . -maxdepth 1 -not -path "./templates" -not -path "./.git" -not -path "."  -not -path "./release" -type d`
do
    folder=$(echo "${i}" | cut -b 3-)
    echo "Copy ${folder} to temp..."
    mkdir -p ${PWD}/release/${folder}/
    cp -r ${PWD}/$folder ${PWD}/release    
done

templates_folder=${PWD}/templates
cd ${PWD}/release

ls

for i in `find . -maxdepth 1 -not -path "." -type d`
do  
    folder=$(echo "${i}" | cut -b 3-)
    echo "Compressing ${folder}..."
    cd ${folder}
    zip -r "${templates_folder}/${folder}.zip" .
    cd ..
done

cd ..

rm -fR ${PWD}/release
