#!/bin/bash
if [ ! $1 ]
then
	echo "未指定文件"
else
	echo "日志文件 or IP地址列表？请输入1或2 "
	read CHS
	if [ $CHS = "1" ]
	then
		zcat $1 | awk -F\" '{print $8}'|sort|uniq|awk -F. '!a[$1$2$3]++{print $1"."$2"."$3".",$4}'|
		while read line
		do
		A=(`echo $line`)
		B=`nslookup ${A[0]}${A[1]} 2>/dev/null`
		if [[ "$B" =~ "baidu" ]]
		then
			printf "%-20s %-8s %-8s\n" ${A[0]}* `grep -c ${A[0]} $1` "True"
		else
			printf "%-20s %-8s %-8s\n" ${A[0]}* `grep -c ${A[0]} $1` "False"
		fi
		done >rst-$1
		sort -t " " -k 2 -nr -o rst-$1 rst-$1
	elif [ $CHS = "2" ]
	then
		cat $1 | awk -F. '!a[$1$2$3]++{print $1"."$2"."$3".",$4}' | 
		while read line
		do
		A=(`echo $line`)
		B=`nslookup ${A[0]}${A[1]} 2>/dev/null`
		if [[ $B =~ "baidu" ]]
		then
			printf "%-20s %-8s %-8s\n" ${A[0]}* `grep -c ${A[0]} $1` "Real"
		else
			printf "%-20s %-8s %-8s\n" ${A[0]}* `grep -c ${A[0]} $1` "Fake"
		fi
		done >rst-$1
		sort -t " " -k 2 -nr -o rst-$1 rst-$1
	else
		echo "数据输入有误"
	fi
fi