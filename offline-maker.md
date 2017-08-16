# 离线安装包制作文档

## 保存最新的acp镜像

先查看一下目前拉取镜像的版本

```bash
jq .version .config
```

保存版本号最新的镜像

```bash
./tools/prepare_images.sh save

# 这条命令会先拉取一下镜像，然后再将这些镜像保存
```

