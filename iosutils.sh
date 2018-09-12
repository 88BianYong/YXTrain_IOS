#!/bin/bash
edition="$1"
mode="$2"
version="$3"
buildno="$4"
echo $edition,$mode,$version,$buildno
if [ "$edition" == "天津版" ];then
bundleName="心理教师"
bundleIdentifier="com.yanxiu.iphone.traing.tianjin"
schema="com.yanxiu.tianjin"
else
bundleName="手机研修"
bundleIdentifier="com.yanxiu.iphone.traing.teacher"
schema="com.yanxiu.lst"
fi
echo $bundleName
echo $bundleIdentifier
echo $schema

phoneDescription="需要您的同意,才能添加照片到相册?"

INFOPLIST_FILE="TrainApp/Phone/InfoPhone.plist"

/usr/libexec/PlistBuddy -c "Set :NSPhotoLibraryAddUsageDescription ${bundleName}${phoneDescription}" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $bundleName" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLName $schema" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $schema" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${version}" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildno}" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $bundleIdentifier" "$INFOPLIST_FILE"
sed -i "" "s/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = ${bundleIdentifier};/g" TrainApp/TrainApp.xcodeproj/project.pbxproj





rm -rf TrainApp/Common/env_config.json
if [ "$edition" == "天津版" ];then
    if [ "$mode" == "release" ];then
       cp -a TrainApp/Config/Tianjin/release/env_config.json TrainApp/Common/env_config.json
    else
       cp -a TrainApp/Config/Tianjin/test/env_config.json TrainApp/Common/env_config.json
    fi
else
    if [ "$mode" == "release" ];then
       cp -a TrainApp/Config/Default/release/env_config.json TrainApp/Common/env_config.json
    else
       cp -a TrainApp/Config/Default/test/env_config.json TrainApp/Common/env_config.json
    fi
fi


rm -rf TrainApp/Phone/PhoneImage/Assets.xcassets/AppIcon.appiconset
rm -rf TrainApp/Phone/PhoneImage/Assets.xcassets/LaunchImage.launchimage
rm -rf TrainApp/Phone/PhoneImage/Assets.xcassets/启动图
rm -rf TrainApp/Phone/PhoneImage/Assets.xcassets/手机研修
rm -rf TrainApp/Phone/PhoneImage/Assets.xcassets/LOGO
if [ "$edition" == "天津版" ];then
cp -a TrainApp/AppIcon\&LaunchImage/Tianjin/ TrainApp/Phone/PhoneImage.xcassets/
else
cp -a TrainApp/AppIcon\&LaunchImage/Default/ TrainApp/Phone/PhoneImage.xcassets/
fi

ENV_FILE="TrainApp/Common/Env/env.h"
sed -i "" '/^.*$/d' "$ENV_FILE"
if [ "$edition" == "天津版" ];then
echo '#define TianjinApp' >>"$ENV_FILE"
fi

