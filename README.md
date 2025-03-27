# Spring Cloud 微服务示例项目

这是一个基于 Spring Cloud 的微服务示例项目，包含以下服务：

- 网关服务 (Gateway Server)
- 用户服务 (User Service)
- 商品服务 (Product Service)
- 配置服务 (Config Server)
- 服务注册中心 (Eureka Server)
- 管理后台 UI (Vue.js)

## 技术栈

- 后端：
  - Spring Cloud
  - Spring Boot
  - Spring Security
  - Spring Data JPA
  - MySQL
  - Eureka
  - Config Server

- 前端：
  - Vue.js 3
  - Element Plus
  - Axios
  - Vue Router

## 功能特性

- 用户认证和授权
- 商品管理
- 分类管理
- 库存管理
- 响应式布局

## 项目结构

```
spring-cloud-demo/
├── gateway-server/        # 网关服务
├── user-service/         # 用户服务
├── product-service/      # 商品服务
├── config-server/        # 配置服务
├── eureka-server/        # 服务注册中心
└── admin-ui/            # 管理后台 UI
```

## 快速开始

1. 克隆项目
```bash
git clone https://github.com/yourusername/spring-cloud-demo.git
cd spring-cloud-demo
```

2. 启动服务
```bash
# 启动 Eureka Server
cd eureka-server
mvn spring-boot:run

# 启动 Config Server
cd ../config-server
mvn spring-boot:run

# 启动其他服务
cd ../gateway-server
mvn spring-boot:run

cd ../user-service
mvn spring-boot:run

cd ../product-service
mvn spring-boot:run

# 启动管理后台
cd ../admin-ui
npm install
npm run serve
```

3. 访问服务
- 管理后台：http://localhost:8080
- 网关服务：http://localhost:9000
- Eureka 控制台：http://localhost:8761

## 配置说明

1. 数据库配置
- 创建 MySQL 数据库
- 修改各服务的 application.yml 中的数据库配置

2. 服务配置
- 修改 config-server 中的配置
- 确保各服务的端口未被占用

## 开发说明

1. 后端开发
- 使用 Spring Boot 2.7.x
- 遵循 RESTful API 设计规范
- 使用统一的响应格式

2. 前端开发
- 使用 Vue 3 组合式 API
- 使用 Element Plus 组件库
- 遵循 Vue 3 最佳实践

## 贡献指南

1. Fork 项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 许可证

MIT License 