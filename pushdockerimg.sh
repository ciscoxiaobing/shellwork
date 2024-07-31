#!/bin/bash

# 定义变量
OLD_IMAGE=$1        # 旧的镜像名称，例如 nginx:latest
NEW_REPO="repo.azurecr.cn"  # 新的镜像仓库

# 检查是否提供了旧的镜像名称
if [ -z "$OLD_IMAGE" ]; then
  echo "Usage: $0 <old_image>"
  exit 1
fi

# 提取镜像名称和标签
IMAGE_NAME=$(echo "$OLD_IMAGE" | awk -F: '{print $1}')
IMAGE_TAG=$(echo "$OLD_IMAGE" | awk -F: '{print $2}')

if [ -z "$IMAGE_TAG" ]; then
  IMAGE_TAG="latest"
fi

# 新的镜像名称
NEW_IMAGE="${NEW_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"

# 登录到新的镜像仓库
ACR_NAME=$(echo "$NEW_REPO" | cut -d'.' -f1)
if ! az acr show --name $ACR_NAME > /dev/null 2>&1; then
  echo "Logging in to $ACR_NAME..."
  az acr login --name $ACR_NAME
  if [ $? -eq 0 ]; then
    echo "Successfully logged in to $ACR_NAME"
  else
    echo "Failed to log in to $ACR_NAME"
    exit 1
  fi
else
  echo "Already logged in to $ACR_NAME"
fi

# 重新标记镜像
echo "Tagging ${OLD_IMAGE} as ${NEW_IMAGE}..."
docker tag "${OLD_IMAGE}" "${NEW_IMAGE}"

# 推送镜像到新的仓库
echo "Pushing ${NEW_IMAGE}..."
docker push "${NEW_IMAGE}"

# 提示成功
echo "Successfully pushed ${OLD_IMAGE} to ${NEW_IMAGE}"
