#!/usr/bin/python  
#-*-coding:utf-8-*-

#keystore信息
#Windows 下路径分割线请注意使用\\转义
keystorePath = "../app/android.keystore"
keyAlias = "dongge"
keystorePassword = "dongge2022"
keyPassword = "dongge2022"

#加固后的源文件名（未重签名）

protectedSourceApkName = "app-release.apk"

#1 将360加固后的apk放到protectedApkResignerForWalle目录下
#2 cd ProtectedApkResignerForWalle
#3 python ApkResigner.py


#加固后的源文件所在文件夹路径(...path),注意结尾不要带分隔符，默认在此文件夹根目录
protectedSourceApkDirPath = ""
#渠道包输出路径，默认在此文件夹Channels目录下
channelsOutputFilePath = ""
#渠道名配置文件路径，默认在此文件夹根目录
channelFilePath = ""
#额外信息配置文件（绝对路径，例如/Users/mac/Desktop/walle360/config.json）
#配置信息示例参看https://github.com/Meituan-Dianping/walle/blob/master/app/config.json
extraChannelFilePath = ""
#Android SDK buidtools path , please use above 25.0+
sdkBuildToolPath = "/Users/xuyimin/Library/Android/sdk/build-tools/29.0.2"

