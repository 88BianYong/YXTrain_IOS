#!/bin/bash
edition="$1"
mode="$2"
version="$3"
buildno="$4"
echo $edition,$mode,$version,$buildno
if [ "$edition" == "天津版" ];then
bundleName="手机研修(天津)"
bundleIdentifier="com.yanxiu.iphone.traing.teacher.tianjin"
schema="com.yanxiu.tianjin"
else
bundleName="手机研修"
bundleIdentifier="com.yanxiu.iphone.traing.teacher"
schema="com.yanxiu.lst"
fi
echo $bundleName
echo $bundleIdentifier
echo $schema

INFOPLIST_FILE="Phone/InfoPhone.plist"

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $bundleName" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLName $schema" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $schema" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${version}" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildno}" "$INFOPLIST_FILE"

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $bundleIdentifier" "$INFOPLIST_FILE"
sed -i "" "s/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = ${bundleIdentifier};/g" TrainApp.xcodeproj/project.pbxproj


rm -rf Common/env_config.json
if [ "$edition" == "天津版" ];then
    if [ "$mode" == "release" ];then
       cp -a Config/Tianjin/release/env_config.json Common/env_config.json
    else
       cp -a Config/Tianjin/test/env_config.json Common/env_config.json
    fi
else
    if [ "$mode" == "release" ];then
       cp -a Config/Default/release/env_config.json Common/env_config.json
    else
       cp -a Config/Default/test/env_config.json Common/env_config.json
    fi
fi


rm -rf Phone/PhoneImage/Assets.xcassets/AppIcon.appiconset
rm -rf Phone/PhoneImage/Assets.xcassets/LaunchImage.launchimage
rm -rf Phone/PhoneImage/Assets.xcassets/启动图
if [ "$edition" == "天津版" ];then
cp -a AppIcon\&LaunchImage/Tianjin/ Phone/PhoneImage.xcassets/
else
cp -a AppIcon\&LaunchImage/Default/ Phone/PhoneImage.xcassets/
fi




