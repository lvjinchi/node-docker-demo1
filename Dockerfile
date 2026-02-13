# 阶段1：构建（仅安装依赖，精简镜像）
FROM node:20-alpine AS builder
WORKDIR /app
# 先复制依赖文件，利用Docker缓存（修改代码不重新装依赖）
COPY package*.json ./
RUN npm install --production

# 阶段2：运行（仅保留运行所需文件）
FROM node:20-alpine
WORKDIR /app

# 创建非root用户（安全优化，避免root运行容器）
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

# 复制构建阶段的产物（仅必要文件）
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./
COPY --chown=nodejs:nodejs app.js ./

# 暴露端口（和代码中一致）
EXPOSE 3000

# 环境变量：生产环境
ENV NODE_ENV=production

# Docker健康检查（检测服务是否正常）
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# 启动命令（exec模式，支持优雅停止）
CMD ["npm", "start"]