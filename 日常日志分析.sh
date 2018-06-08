#!/bin/bash
rm real.log to8to.log 2>/dev/null

#判断是否指定了日志文件，如果没有则进行下载
if [ ! $1 ]
then
    printf "未指定日志文件，下载前一天日志？ y/n "
    read CHS
    if [ ${CHS} = "y" ]
    then 
        wget --ftp-user='ftpuser_baidu' --ftp-password='ftpuser_baidu@@)!%' ftp://192.168.3.4:11211/baidusearch-`date -d "-1 day" +%Y-%m-%d`.tar.gz
        rename baidusearch- "" *.tar.gz
        GZ=`date -d "-1 day" +%Y-%m-%d`".tar.gz"
		zcat $GZ | egrep -av 'shejiben.com|to8to_baidu.log' >to8to.log
		RZ=to8to.log

    else
        echo "请重行运行脚本并指定日志文件"
        exit
    fi
else
    if [[ -e $1 && $1 =~ ".log" ]]
    then
        RZ=$1
    elif [[ -e $1 && $1 =~ ".gz" ]]
    then
        zcat $1 | egrep -av 'shejiben.com|to8to_baidu.log' >to8to.log
        RZ=to8to.log
    else
        echo "文件格式错误，请重新运行脚本并指定日志文件"
        exit
     fi
fi

#提取真蜘蛛的记录
grep -a '123.125.71\|123.125.67\|180.76.15\|220.181.108\|220.181.51\|111.206.36.\|115.239.212.' $RZ >real.log

#统计真假蜘蛛的记录数量
ZZZ=`cat real.log | wc -l`
ALL=`cat to8to.log | wc -l`
echo -e "真蜘蛛\t${ZZZ}" 
echo -e "假蜘蛛\t"`echo ${ALL}-${ZZZ}|bc `

#显示各状态码数量
printf "\n\n状态码:\n\n" 
awk '{print $10}' real.log |sort|uniq -c|sort -r | awk '{print $2,$1}' OFS="\t"

#主要目录200数量
printf "\n\n主要目录200数量:\n\n" 
echo -e "问题页\t"`egrep -ac '^www.to8to.com.*/ask/k' real.log`
echo -e "文章页\t"`egrep -ac '^www.to8to.com.*/yezhu/[zv][0-9]+.html' real.log`
echo -e "图片页\t"`egrep -ac '^xiaoguotu.to8to.com.*/[cp][0-9]+.html' real.log`

#抓取最多URL
printf "\n\n抓取最多页面\n\n"
awk '{print $1$8}' real.log | sort | uniq -c | sort -nr | head -20

#常见404 URL数量
# printf "\n\n常见404数量:\n\n"
# sltype=(
# /riji/[0-9]+$   #末尾少斜杠的日记详情页，如 http://www.to8to.com/riji/3933158
# /zs/[a-z0-9]+$  #末尾少斜杠的装修公司博客频道，如 http://sz.to8to.com/zs/company728337
# ^.*\.to8to.com/$    #不存在的子域名首页，如 http://unexist.to8to.com
# /robots.txt$
# /yezhu/http
# ^[a-z]+.to8to.com/company/[a-z]+
# /ask/k[0-9]+[.]*?.*
# xiaoguotu.to8to.com/[pc][0-9]+.html
# /ask/http
# [wm]+.to8to.com/ask/k\(\\d+\).html
# m.to8to.com/bbs/
# jiaju.to8to.com/brand/\(\\d+\)$
# [a-z0-9]+.to8to.com/$
# jiaju.to8to.com/[a-z]+/[a-z0-9]+$
# )
# for i in ${sltype[@]}
# do
# echo -e `awk '$10==404{print $1$8}' real.log | egrep -c $i`"\t"$i
# done | sort -nr
