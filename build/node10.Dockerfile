# 导入环境变量
ARG NODE_VERSION=latest
ARG YARN_EXTENSIONS=gulp


# 使用 Node.js 官方镜像
FROM node:${NODE_VERSION}

# 安装指定版本的 yarn
ARG YARN_VERSION=latest
RUN npm install -g yarn@${YARN_VERSION} && yarn global add ${YARN_EXTENSIONS}
