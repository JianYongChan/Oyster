#!/bin/bash

# 图片存放目录
PICTURE_DIR="$HOME/Pictures/bing-wallpapers"
# 必应网址
BING="http://www.bing.com"
# 获取xml数据
# 其中idx值决定从何时开始，0表示当日，1表示前一天
xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-WW"
# 图片分辨率
picResolution="_1920x1200"
# 图片后缀
picExtension=".jpg"

fileName=$(date +%Y%m%d%H%M%S)$picExtension

# 根据操作系统类型确定grep工具
# 由于Mac自带的grep命令不支持perl(-p)
# 所以需要使用brew下载grep工具
# 但是一般不覆盖原生的grep，所以取名为ggrep
OS=$(uname -a)
if [ "$OS" =  "Linux" ]; then
    greptool="grep"
elif [ "$OS" = "Darwin" ]; then
    greptool="ggrep"
fi


# picURL=$BING$(echo $(curl -s "$xmlURL") | $greptool -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)"$picResolution""$picExtension"

# 使用perl正则表达式
picURL=$BING$(echo $(curl -s "$xmlURL") | ggrep -oP '(?<=<urlBase>).*(?=</urlBase>)')$picResolution$picExtension

# echo "picURL: $picURL"
# echo "fileName: $fileName"



# 检测目录是否存在，不存在则创建
if [ -e "$PICTURE_DIR" ]; then
    echo "目录存在，直接下载图片..."
else
    echo "目录不存在，创建目录: $PICTURE_DIR"
    mkdir -p "$PICTURE_DIR"
fi

# 下载到指定目录
echo "下载图片... "
curl -s -o "$PICTURE_DIR/$fileName" "$picURL"
echo "图片下载完成， 保存至$PICTURE_DIR/$fileName"

exit

# TODO: 可以指定日期下载图片
