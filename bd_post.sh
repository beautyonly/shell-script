#!/bin/bash
# 文件为空停止推送；配额用完停止推送
if [[ -z $2 ]]
then
   echo "请补充推送类型，如 bash bd_post.sh mip"
   exit
elif [[ $2 == 'mip' ]]
then
    args='?site=m.to8to.com&token=xxx&type=mip'
elif [[ $2 == 'realtime' ]]
then
    args='?appid=1544600954734097&token=xxx&type=realtime'
elif [[ $2 == 'batch' ]]
then
    args='?appid=1544600954734097&token=xxx&type=batch'
elif [[ $2 == 'yc' ]]
then
    args='?appid=1544600954734097&token=xxx&type=realtime,original'
else
    args='?site=m.to8to.com&token=xxx'
fi
    
head -5 $1 >urls.txt
remain=1
url_num=1

while ((remain > 0 && url_num > 0))
do
    #sleep 1
    res=`curl -s -H 'Content-Type:text/plain' --data-binary @urls.txt "http://data.zz.baidu.com/urls${args}"`
    statu=`echo ${res} | egrep -c 'success'`
    if [[ ${statu} > 0 ]]
    then
        echo ${res}
        remain=`echo ${res} | egrep -o '[0-9]+}$' | egrep -o '[0-9]+'`
        sleep 0.5
        sed -i '1,5d' $1
        url_num=`cat $1 | wc -l`
        head -5 $1 >urls.txt
    else
        echo ${res}
        #sleep 0.5
    fi
done

rm $1
