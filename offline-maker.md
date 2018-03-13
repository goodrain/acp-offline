# 离线安装包制作文档

## 一、获取包并保存

先查看一下目前拉取镜像的版本

```bash
jq .version config.json
```

### 1.1 拉取最新的镜像

```bash
./tools/prepare_images.sh pull
```



### 1.2保存最新的acp镜像

保存版本号最新的镜像

```bash
# 保存命令会将系统中的镜像id和已经保存的镜像id进行比较，如果一致就跳过。
./tools/prepare_images.sh save
```

### 1.3 下载最新的rpm包

```bash
./tools/download_rpms.sh default
```

### 1.4 下载最新安装包
```bash
ossutil cp oss://rainbond-pkg/ packages -r -f -u
```


## 二、将更新的镜像包上传到阿里oss

```bash
# 上传之前会先生成最新的文件列表
# 镜像文件会自动与远程oss文件进行比较，不一致才上传，repo文件进行更新覆盖上传
./tools/upload_oss.sh
```
