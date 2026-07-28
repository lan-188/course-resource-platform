#!/bin/bash
# ===========================================
# 软件测试教学管理平台 - 阿里云 ECS 一键部署
# 用法: bash deploy-ecs.sh
# ===========================================

set -e

echo "========================================="
echo "  教学平台 - 阿里云 ECS 部署脚本"
echo "========================================="

# ---------- 1. 安装 Docker ----------
if ! command -v docker &>/dev/null; then
    echo "[1/5] 安装 Docker..."
    curl -fsSL https://get.docker.com | bash
    systemctl start docker
    systemctl enable docker
else
    echo "[1/5] Docker 已安装 ✓"
fi

# ---------- 2. 安装 Docker Compose ----------
if ! docker compose version &>/dev/null 2>&1; then
    echo "[2/5] 安装 Docker Compose..."
    curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    echo "[2/5] Docker Compose 已安装 ✓"
fi

# ---------- 3. 克隆项目 ----------
PROJECT_DIR="/opt/teaching-platform"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "[3/5] 克隆项目..."
    git clone https://github.com/lan-188/course-resource-platform.git "$PROJECT_DIR"
else
    echo "[3/5] 项目已存在，拉取最新代码..."
    cd "$PROJECT_DIR" && git pull
fi

# ---------- 4. 配置安全组（提示） ----------
echo "[4/5] 请确保阿里云安全组已开放以下端口:"
echo "       8080 (应用端口)"
echo "       3306 (MySQL，仅建议本地访问)"
echo ""
echo "   🖐 按 Enter 继续部署..."
read -r

# ---------- 5. 启动服务 ----------
echo "[5/5] 启动服务..."
cd "$PROJECT_DIR/backend"

# 生成随机数据库密码（如未设置）
if [ -z "$DB_PASSWORD" ]; then
    DB_PASSWORD=$(openssl rand -base64 12 2>/dev/null || echo "teaching_platform_2024")
    echo "   → 已生成数据库密码: $DB_PASSWORD"
    echo "   → 请妥善保存此密码！"
fi

DB_PASSWORD=$DB_PASSWORD docker compose up -d --build

echo ""
echo "========================================="
echo "  ✅ 部署完成！"
echo "========================================="
echo "  后端 API: http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_ECS_IP'):8080/api"
echo "  数据库密码: $DB_PASSWORD"
echo ""
echo "  查看日志: cd $PROJECT_DIR/backend && docker compose logs -f"
echo "  重启服务: cd $PROJECT_DIR/backend && docker compose restart"
echo "  停止服务: cd $PROJECT_DIR/backend && docker compose down"
echo "========================================="
