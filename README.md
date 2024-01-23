# 目标
生成修改过期时间的kubeadm.并实现Dockerfile自动打包

## 来源
 基于这篇文章进行的编译修改
 https://sysin.org/blog/kubernetes-kubeadm-cert-100y

## 使用
默认范围内的版本.新建相应分支就可以实现打包(1.17-1.25).其中的分支和kubernetes分支对应即可   
后面的版本有时间可以兼容  
核心就是sed修改了几个变量   

直接使用build.sh 就可以打包.在国内编译默认需要设置https_proxy   
就会在目录/dist 下面有打包好的文件  
也可以直接使用 release页面   

## 计划
使用github action来帮助打包
