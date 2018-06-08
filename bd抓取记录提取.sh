#!/bin/bash

#脚本接受2个参数
#第1个是需提取记录的URL文件，第2个是日志压缩文件

#清理目录
rm rst.log to8to_baidu.log &>/dev/null

#预处理URL文件，去掉文件行末\r，去掉行首http[s]
sed -i -r 's/\r//g' $1
sed -i -r 's/https*:\/\///g' $1

#提取抓取记录，有多条抓取记录时取最后一条
for i in `cat $1`
do
A=(`echo $i | sed 's/com/com /g'`)
R1=`zgrep -a "${A[0]}.*${A[1]}" $2 | tail -1`
if [[ $R1 != "" ]]
then
	echo "${i},"`echo $R1 | awk '{print $10}'` >>rst.log
else
	echo "${i},未抓取" >>rst.log
fi
done

#输出状态码汇总结果
awk -F, '{print $1}' rst.log | sort | uniq -c | sort -r