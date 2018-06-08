#!/bin/bash

#自主适配检查
TESTURL=(
http://www.to8to.com/
http://cq.to8to.com/
http://bj.to8to.com/
http://nj.to8to.com/
http://sh.to8to.com/
http://gz.to8to.com/
http://sz.to8to.com/
http://xiaoguotu.to8to.com/
http://xiaoguotu.to8to.com/list-h1s1i0
http://xiaoguotu.to8to.com/list-h2s1i0
http://xiaoguotu.to8to.com/search/34669
http://xiaoguotu.to8to.com/c10019087.html
http://xiaoguotu.to8to.com/p629281.html
http://www.to8to.com/gonglve/
http://www.to8to.com/riji/
http://www.to8to.com/yezhu/
http://www.to8to.com/yezhu/fangchan/
http://www.to8to.com/yezhu/list-h9s4
http://www.to8to.com/yezhu/z16078.html
http://www.to8to.com/yezhu/v2712.html
http://www.to8to.com/ask/
http://www.to8to.com/ask/more-h2i5
http://www.to8to.com/ask/k13194.html
http://www.to8to.com/ask/search/4008
http://www.to8to.com/baike/776
http://sz.to8to.com/company/
http://news.to8to.com/
http://news.to8to.com/article/100572.html
http://mall.to8to.com
http://mall.to8to.com/tag/cizhuan/
http://mall.to8to.com/temai/13435.html
http://www.to8to.com/yezhu/zxbj.php
)

echo -e "\e[32;7m自主适配检查\e[0m"
for i in ${TESTURL[@]}
do
RST=`curl -s -I $i -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1' | grep 'Location' | sed 's/Location: //g'`
if [[ $RST = "" ]]
then
	echo -e "\e[31m$i 未能自主适配\e[0m"
	sleep 0.5s
else
	echo -e $i"\t"$RST
	sleep 0.5s
fi
done


#内容对应检查
rm PC H5 2>/dev/null
SP(){
	RST=`diff PC H5 | wc -l`
	if [[ $RST != 0 ]]
	then
		echo -e "$i\t\e[31mPC H5 内容不对应\e[0m"
	else
		echo -e "$i\t\e[32mOK\e[0m"
	fi
}

TESTURL=(
http://xiaoguotu.to8to.com/list-h1s1i0
http://xiaoguotu.to8to.com/search/86332
http://www.to8to.com/ask/more-h2i5
http://www.to8to.com/ask/search/4008
http://www.to8to.com/yezhu/fangchan/
http://www.to8to.com/yezhu/list-h9s4
http://www.to8to.com/baike/100002/
)
echo -e "\n\e[32;7m列表页内容对应检查\e[0m"
for i in ${TESTURL[@]}
do
if [[ $i =~ "xiaoguotu" ]]
then
	curl -s $i | egrep '<a target="_blank" href="/[cp][0-9]+.html.*" title="' | sed -e 's/^.*">//g' -e 's/<\/a>//g' | sort >PC
	H5URL=`echo $i | sed 's/xiaoguotu.to8to.com/m.to8to.com\/xiaoguotu/g'`
	curl -s $H5URL | egrep '^\s+alt' | sed -r 's/^\s+alt="(.*)"/\1/g' | sort >H5
	SP

elif [[ $i =~ "ask" ]]
then
	curl -s $i | egrep -o 'class="ect".*</a>$' | sed -r 's/class=.*\[.*\](.*)<\/a>/\1/g;s/<em class="ask_word">(.*)<\/em>/\1/g' | sort >PC
	H5URL=`echo $i | sed 's/www/m/g'`
	curl -s $H5URL | egrep -o 'class="zxask-[a-z]+-title".*</[ah2]+>$' | sed -r 's/<b style="color: red;">(.*)<\/b>/\1/g;s/^class.*>(.*)<\/[ah2]+>/\1/g' | sort >H5
	SP

elif [[ $i =~ "yezhu" ]]
then
	curl -s $i | grep 'list-item-title' | sed -r 's/^\s+<div.*.html">(.*)<\/a><\/div>/\1/g' | sort | sed -r 's/\r//g'>PC
	H5URL=`echo $i | sed 's/www/m/g'`
	curl -s $H5URL | grep '<img alt=' | sed -r 's/^\s+<img alt="(.*)"\s+src=.*$/\1/g' | sort >H5
	SP

else
	curl -s $i | egrep '<a target="_blank".*</a>$' | sed -r 's/^\s+<a.*>(.*)<\/a>/\1/g' | sort >PC
	H5URL=`echo $i | sed 's/www/m/g'`
	curl -s $H5URL | egrep '^\s+<h2>.*</h2>$' | sed -r 's/^\s+<h2>(.*)<\/h2>/\1/g' | sort >H5
	SP
	
fi
done
rm PC H5
