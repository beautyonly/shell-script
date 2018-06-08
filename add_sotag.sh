#!/bin/bash
#自动添加so域名标签并推送到百度

cookies=''  #手动填写

cat $1 | while read line
do
    A=(`echo $line`)
    name=`echo ${A[0]}`
    word=`echo ${A[1]}`
    title=`echo "${A[2]}_${A[4]}"`
    desc=`echo ${A[5]}`
    bd=`echo ${A[6]}`
    
    #echo $name $title $word $bd
    http -b -f POST 'http://www.to8to.com/trdn/sotage_manage.php?act=add' "Cookie:${cookies}" bq_name=${name} title=${title} keywords=${word} desc=${desc} baidu_index=${bd} < /dev/tty > /dev/null && echo $name "添加成功"
    sleep 1
    
    tagid=`curl -s --cookie "${cookies}" 'http://www.to8to.com/trdn/sotage_manage.php'  | egrep -o '<td>[0-9]+</td>' | head -1 | egrep -o '[0-9]+'` && echo "http://so.to8to.com/$tagid"
    sleep 1
    
    msg=`curl -s -H "Content-Type:text/plain" --data "http://so.to8to.com/${tagid}" "http://data.zz.baidu.com/urls?site=so.to8to.com&token=VzF8UZfWVdwKGYuR"`
    echo -e "${msg}\n"
    sleep 1
done
