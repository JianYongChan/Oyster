#!/bin/bash

# 图片存放目录
PICTURE_DIR="$HOME/Pictures/bing-wallpapers"
# 必应网址
BING="http://www.bing.com"
# 图片分辨率
picResolution="_1920x1200"
# 图片后缀
picExtension=".jpg"

# 输入的时间偏移量，0表示当日，1表示前一天
if [ -n "$2" ]; then
    offset="0"
elif [[ $1 -lt 0 ]]; then
    echo "参数必须为非负数"
    exit 1
else
    offset=$1
fi
# 由于每天只有一张图片
# 所以可以根据日期来对图片命名
day=$(( $(date +%d) - $offset ))
if [[ $day -lt 10 ]]; then
    day="0"$day
fi
fileName=$(date +%Y%m)$day$picExtension
# echo "fileName: $fileName"

# 获取xml数据
# 其中idx值决定从何时开始，0表示当日，1表示前一天
xmlURL="$BING/HPImageArchive.aspx?format=xml&idx=$offset&n=1&mkt=en-WW"

# 根据操作系统类型确定grep工具
# 由于Mac自带的grep命令不支持perl(-P)
# 所以需要使用brew下载grep工具
# 但是一般不覆盖原生的grep，所以取名为ggrep
OS=$(uname -s)
if [ "$OS" ==  "Linux" ]; then
    greptool="grep"
elif [ "$OS" == "Darwin" ]; then
    greptool="ggrep"
fi


# 获取图片的url
# 这里使用了perl正则表达式
picURL=$BING$(echo $(curl -s "$xmlURL") | $greptool -oP '(?<=<urlBase>).*(?=</urlBase>)')$picResolution$picExtension

# echo "picURL: $picURL"

# 检测目录是否存在，不存在则创建
if [ ! -e "$PICTURE_DIR" ]; then
    echo "目录不存在，创建目录: $PICTURE_DIR"
    mkdir -p "$PICTURE_DIR"
fi

# 下载到指定目录
echo "下载图片... "
curl -s -o "$PICTURE_DIR/$fileName" "$picURL"
echo "图片下载完成， 保存至$PICTURE_DIR/$fileName"

exit 0
