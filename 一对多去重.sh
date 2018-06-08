#!/bin/bash

#先给文件都排序
for i in `ls *.txt`
do
    sort $i -o $i
done

#创建需去重文件的副本
cp $1 fb

#将老词文件逐个『与副本去重，结果保存为tmp后再去一次重』
for i in `ls 老词*.txt`
do
    comm -23 fb $i >tmp
    comm -23 tmp $i >fb
done

mv fb rst.txt
rm tmp
