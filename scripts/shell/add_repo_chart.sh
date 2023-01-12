#!/usr/bin/env bash

#获取脚本所存放目录
cd `dirname $0`
bash_path=`pwd`

chart_path="$1"
charts_dir="/tmp"
charts_url="http://ygqygq2.github.io/charts"

## 不使用 helm package 将依赖包打进来
# helm package $chart_path
version=$(cat $chart_path/Chart.yaml | egrep '^version' | awk -F': ' '{print $2}')
chart_basename=$(basename $chart_path)
chart_dirname=$(dirname $chart_path)
echo tar ${chart_basename}-${version}.tgz
tar -C $chart_dirname -zcvf ${chart_basename}-${version}.tgz $chart_basename
\mv -f *.tgz $charts_dir
helm repo index $charts_dir --url $charts_url

