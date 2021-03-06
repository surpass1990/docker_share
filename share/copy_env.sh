#!/bin/bash

#------------------------------------------------------------------------
#author		:	zc.ding
#filename	:	copy_env.sh
#date		:	2018-08-10
#
#-----------------------------------------------------------------------

config_path=`source ./readIni.sh global config_path`
src_path=`source ./readIni.sh "$1" src_path`
env_path=`source ./readIni.sh "$1" env_path`
branch_name=`source ./readIni.sh "$1" branch_name`

cd $env_path

sed -i 's/HKJF-TEST-.*/HKJF-TEST-'$branch_name'-/g' common/env_common.properties
sed -i 's/CXJ-TEST-.*/CXJ-TEST-'$branch_name'-/g' common/env_common.properties

echo "遍历所有配置文件." ${env_path}

for filename in ` ls env* `
do
    SERVICE_NAME=${filename%%.*}
    SERVICE_NAME=${SERVICE_NAME:4:100}
    TARGET_PATH=$src_path"/finance-$SERVICE_NAME/finance-$SERVICE_NAME-service/src/main/resources/env/"
    rm -rf $TARGET_PATH
    mkdir -p $TARGET_PATH
    cp  -a  $filename $TARGET_PATH
    TARGET_PATH=$src_path"/finance-$SERVICE_NAME/finance-$SERVICE_NAME-service/src/main/resources"
    rm -rf $TARGET_PATH/log4j.properties $TARGET_PATH/log4j.xml
    cp  -a common/log4j.xml  $TARGET_PATH
    TARGET_PATH=$src_path"/env"
    rm -rf $TARGET_PATH
    mkdir -p $TARGET_PATH
    cp  -a common/env_common.properties  $TARGET_PATH/
done 

echo "拷贝management配置文件"
TARGET_PATH=$src_path"/hk-management-services/src/main/resources/env/"
rm -rf $TARGET_PATH
mkdir -p $TARGET_PATH
cp  -a $env_path/web-conf/management/env_test.properties   $TARGET_PATH
cp -a common/env_common.properties $src_path/hk-management-services/src/main/resources/


#if [[ $1 == *cxj* ]]
#then

	echo "拷贝api配置文件"
	TARGET_PATH=$src_path"/hk-api-services/src/main/resources/env/"
	rm -rf $TARGET_PATH
	mkdir -p $TARGET_PATH
	cp  -a $env_path/web-conf/api/env_test.properties   $TARGET_PATH
	cp -a common/env_common.properties $src_path/hk-api-services/src/main/resources/    
#fi

if [[ $1 == *hk* ]]
then
	echo "拷贝financial配置文件"
	TARGET_PATH=$src_path"/hk-financial-services/src/main/resources/env/"
	rm -rf $TARGET_PATH
	mkdir -p $TARGET_PATH
	cp  -a $env_path/web-conf/financial/env_test.properties   $TARGET_PATH
	cp -a common/env_common.properties $src_path/hk-financial-services/src/main/resources/    

	echo "拷贝BI配置文件"
        TARGET_PATH=$src_path"/hk-bi-services/src/main/resources/env/"
        rm -rf $TARGET_PATH
        mkdir -p $TARGET_PATH
        cp  -a $env_path/web-conf/bi/env_test.properties   $TARGET_PATH
        cp -a common/env_common.properties $src_path/hk-bi-services/src/main/resources/
fi
cd $config_path
exit
