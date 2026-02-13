// 引入express框架（极简Web服务）
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// 基础接口：首页
app.get('/', (req, res) => {
  res.send(`
    <h1>Test1! 🚀</h1>
    <h1>Hello Docker + Node.js! 🚀</h1>
    <p>当前时间：${new Date().toLocaleString()}</p>
    <p>访问 <a href="/health">/health 查看健康状态</a></p>
  `);
});

// 健康检查接口（适配Docker/ECS健康检查）
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    service: 'node-docker-demo',
    timestamp: new Date().toISOString()
  });
});

// 启动服务（必须监听0.0.0.0，否则容器外无法访问）
app.listen(port, '0.0.0.0', () => {
  console.log(`服务运行在 http://0.0.0.0:${port}`);
});