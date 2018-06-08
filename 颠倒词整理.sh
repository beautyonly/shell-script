#此脚本可提取出颠倒词
#运行速度视文件大小决定，40W个关键词时，处理每个词平均需要2s，建议多机器、多窗口运行


# line='中式别墅客厅装修效果图'
head -100 $1 | while read line
do
	cp $1 tmp
	for i in $(seq ${#line})
	do
		grep ${line[$i]} tmp > 副本 && sleep 0.1 && mv 副本 tmp
	done

	cat tmp | while read keyword
	do
		if [[ ${line} != ${keyword} ]]
		then
			if [[ `echo ${line} | sed 's/./&\n/g' | sort` == `echo ${keyword} | sed 's/./&\n/g' | sort` ]]
			then
				echo ${keyword}
			fi
		else
			continue
		fi
	done | sed ":a;N;s/\n/\;/;ta;" | sed "s/^/${line};/g" >>颠倒词.txt
done

rm tmp