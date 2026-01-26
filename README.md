# OceanBase Course Vercel Demo

这是一个基于 **OceanBase Cloud**、**Next.js** 和 **Vercel** 构建的大学选课后台管理系统演示。通过这个系统，您可以管理课程信息、查看课程详情、添加和删除评价、编辑课程容量等。

## ✨ 特性

- 🚀 **Next.js 14** - 使用最新的 Next.js App Router
- 🗄️ **OceanBase Cloud** - 兼容 MySQL 的分布式关系数据库
- 🔌 **数据库连接** - 简洁的数据库连接管理
- 📡 **RESTful API** - 完整的课程和评价管理 API
- 🎨 **现代化 UI** - 美观的用户界面
- ⚡ **Vercel 部署** - 一键部署到 Vercel
- 📚 **课程管理** - 完整的课程 CRUD 操作
- ⭐ **评价系统** - 课程评价和评分功能
- 👥 **容量管理** - 动态调整课程可选人数

## 🏗️ 项目结构

```
.
├── app/
│   ├── api/
│   │   ├── courses/
│   │   │   ├── route.ts              # 课程列表和创建 API
│   │   │   ├── [id]/
│   │   │   │   ├── route.ts          # 单个课程操作 API
│   │   │   │   ├── capacity/
│   │   │   │   │   └── route.ts      # 更新课程容量 API
│   │   │   │   └── reviews/
│   │   │   │       └── route.ts     # 课程评价 API
│   │   └── reviews/
│   │       └── [id]/
│   │           └── route.ts         # 删除评价 API
│   ├── layout.tsx                    # 根布局
│   ├── page.tsx                      # 主页面
│   └── globals.css                   # 全局样式
├── lib/
│   ├── db.ts                         # 数据库连接工具
│   └── init.sql                      # 数据库初始化脚本
├── env.template                       # 环境变量模板
├── next.config.js                     # Next.js 配置
├── package.json                       # 项目依赖
└── README.md                          # 项目文档
```

## 🚀 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 配置 OceanBase Cloud 连接

创建 `.env` 文件，填入你的 OceanBase Cloud 连接信息：

```env
# OceanBase Cloud 数据库连接配置
OCEANBASE_HOST=your-oceanbase-host.ocp.aliyuncs.com
OCEANBASE_PORT=3306
OCEANBASE_USER=your_username
OCEANBASE_PASSWORD=your_password
OCEANBASE_DATABASE=your_database_name
```

### 3. 运行开发服务器

```bash
npm run dev
```

打开 [http://localhost:3000](http://localhost:3000) 查看应用。

数据库会在首次访问时自动初始化，创建课程和评价数据表，并插入示例数据。

## 📦 部署到 Vercel

### 方法 1: 使用 Vercel CLI

1. 安装 Vercel CLI：

```bash
npm i -g vercel
```

2. 登录 Vercel：

```bash
vercel login
```

3. 部署项目：

```bash
vercel
```

### 方法 2: 通过 GitHub 集成

1. 将代码推送到 GitHub 仓库
2. 在 [Vercel Dashboard](https://vercel.com/dashboard) 中导入项目
3. 配置环境变量：
   - 进入项目设置
   - 添加所有 `.env` 中的环境变量
4. 部署完成！

## 🔧 环境变量配置

在 Vercel 项目中，需要在项目设置中添加以下环境变量：

| 变量名 | 说明 | 必填 | 默认值 |
|--------|------|------|--------|
| `OCEANBASE_HOST` | 数据库主机地址 | ✅ | localhost |
| `OCEANBASE_PORT` | 数据库端口 | ❌ | 3306 |
| `OCEANBASE_USER` | 数据库用户名 | ✅ | root |
| `OCEANBASE_PASSWORD` | 数据库密码 | ✅ | - |
| `OCEANBASE_DATABASE` | 数据库名称 | ✅ | test |

## 📚 API 文档

### 课程管理

#### 获取所有课程

```http
GET /api/courses
GET /api/courses?department=Computer Science
GET /api/courses?semester=Fall 2024
```

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "code": "CS101",
      "name": "Introduction to Computer Science",
      "description": "...",
      "instructor": "Dr. Sarah Johnson",
      "department": "Computer Science",
      "credits": 3,
      "capacity": 50,
      "enrolled": 45,
      "semester": "Fall 2024"
    }
  ]
}
```

#### 获取单个课程详情

```http
GET /api/courses/[id]
```

#### 创建新课程

```http
POST /api/courses
Content-Type: application/json

{
  "code": "CS101",
  "name": "Introduction to Computer Science",
  "description": "An introductory course...",
  "instructor": "Dr. Sarah Johnson",
  "department": "Computer Science",
  "credits": 3,
  "capacity": 50,
  "semester": "Fall 2024"
}
```

#### 更新课程信息

```http
PUT /api/courses/[id]
Content-Type: application/json

{
  "name": "Updated Course Name",
  "description": "...",
  "instructor": "...",
  "department": "...",
  "credits": 4,
  "capacity": 60,
  "semester": "Spring 2024"
}
```

#### 更新课程容量

```http
PUT /api/courses/[id]/capacity
Content-Type: application/json

{
  "capacity": 60
}
```

#### 删除课程

```http
DELETE /api/courses/[id]
```

### 评价管理

#### 获取课程的所有评价

```http
GET /api/courses/[id]/reviews
```

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "course_id": 1,
      "student_name": "Alice Zhang",
      "rating": 5,
      "comment": "Excellent course!",
      "created_at": "2024-01-01T00:00:00.000Z"
    }
  ]
}
```

#### 添加课程评价

```http
POST /api/courses/[id]/reviews
Content-Type: application/json

{
  "student_name": "Alice Zhang",
  "rating": 5,
  "comment": "Excellent course!"
}
```

#### 删除评价

```http
DELETE /api/reviews/[id]
```

## 🗄️ 数据库结构

### 课程表 (courses)
- `id` - 课程 ID
- `code` - 课程代码（唯一）
- `name` - 课程名称
- `description` - 课程描述
- `instructor` - 授课教师
- `department` - 所属院系
- `credits` - 学分
- `capacity` - 课程容量
- `enrolled` - 已选人数
- `semester` - 学期
- `created_at` - 创建时间
- `updated_at` - 更新时间

### 评价表 (reviews)
- `id` - 评价 ID
- `course_id` - 课程 ID
- `student_name` - 学生姓名
- `rating` - 评分（1-5）
- `comment` - 评价内容
- `created_at` - 创建时间

## 🛠️ 技术栈

- **Next.js 14** - React 框架
- **TypeScript** - 类型安全
- **MySQL2** - MySQL 客户端（兼容 OceanBase）
- **OceanBase Cloud** - 分布式关系数据库

## 🎯 功能特性

### 课程管理
- ✅ 查看所有课程列表
- ✅ 按院系和学期筛选课程
- ✅ 创建新课程
- ✅ 查看课程详情
- ✅ 更新课程信息
- ✅ 更新课程容量
- ✅ 删除课程

### 评价系统
- ✅ 查看课程的所有评价
- ✅ 添加课程评价（1-5 星评分）
- ✅ 删除评价
- ✅ 显示评价统计

### 用户界面
- ✅ 响应式设计
- ✅ 课程卡片展示
- ✅ 模态框查看详情
- ✅ 实时容量显示
- ✅ 星级评分系统

## 🔒 安全注意事项

1. **永远不要**将 `.env` 文件提交到版本控制系统
2. 在生产环境中使用强密码
3. 考虑使用 Vercel 的环境变量加密功能
4. 限制数据库用户的权限，只授予必要的权限

## 📝 许可证

MIT

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📞 支持

如有问题，请访问：
- [OceanBase 官方文档](https://www.oceanbase.com/docs)
- [Vercel 文档](https://vercel.com/docs)
- [Next.js 文档](https://nextjs.org/docs)

## 🙏 致谢

感谢 OceanBase Cloud 和 Vercel 提供的强大平台支持。
