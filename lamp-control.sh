#!/bin/bash

# LAMP Stack Control Script
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

print_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 LAMP Stack Control                     ║"
    echo "║                Apache 2.4 + PHP 7.4 + MariaDB 10.11         ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_usage() {
    print_banner
    echo -e "${BOLD}Usage: $0 [command]${NC}"
    echo ""
    echo -e "${GREEN}🚀 Main Commands:${NC}"
    echo "  start     - Start LAMP stack"
    echo "  stop      - Stop LAMP stack"
    echo "  restart   - Restart LAMP stack"
    echo "  rebuild   - Rebuild and start containers"
    echo ""
    echo -e "${BLUE}📊 Monitoring:${NC}"
    echo "  status    - Show container status"
    echo "  logs      - Show all logs"
    echo "  logs-apache - Show Apache logs"
    echo "  logs-mariadb - Show MariaDB logs"
    echo ""
    echo -e "${YELLOW}🔧 Utilities:${NC}"
    echo "  shell     - Access Apache container shell"
    echo "  mysql     - Access MariaDB shell"
    echo "  info      - Show system information"
    echo "  test      - Run connection tests"
    echo "  clean     - Clean up containers and volumes"
    echo ""
    echo -e "${CYAN}📁 Project Management:${NC}"
    echo "  create-project <name> - Create new project folder"
    echo "  hosts     - Show hosts file entries to add"
    echo ""
}

show_info() {
    echo -e "${CYAN}📊 LAMP Stack Information:${NC}"
    echo ""
    echo -e "${GREEN}🌐 Access URLs:${NC}"
    echo "  • Apache: http://localhost:8090"
    echo "  • LogProStyle (shared): http://logprostyle.local:8090"
    echo "  • Local projects: http://lamp.local:8090"
    echo "  • Test site: http://test.local:8090"
    echo "  • phpMyAdmin: http://localhost:8082"
    echo "  • HTTPS: https://localhost:8443"
    echo ""
    echo -e "${BLUE}🔌 Database Connection:${NC}"
    echo "  • Host: localhost (or mariadb from container)"
    echo "  • Port: 3307"
    echo "  • Database: lamp_db"
    echo "  • Username: lamp_user"
    echo "  • Password: lamp_pass"
    echo "  • Root Password: passrootDanh123@"
    echo ""
    echo -e "${YELLOW}📁 Directory Structure:${NC}"
    echo "  • Local projects: ./src/"
    echo "  • Shared projects: /var/www/shared/"
    echo "  • Apache logs: ./logs/apache/"
    echo "  • Config files: ./config/"
    echo ""
    echo -e "${RED}⚠️  Add to /etc/hosts:${NC}"
    echo "127.0.0.1 logprostyle.local"
    echo "127.0.0.1 lamp.local"
    echo "127.0.0.1 test.local"
}

test_connections() {
    echo -e "${BLUE}🧪 Testing connections...${NC}"
    echo ""
    
    # Test Apache
    echo -n "Apache (port 8090): "
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8090 | grep -q "200\|403\|301\|302"; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
    
    # Test phpMyAdmin
    echo -n "phpMyAdmin (port 8082): "
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8082 | grep -q "200\|403"; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
    
    # Test MariaDB
    echo -n "MariaDB (port 3307): "
    if nc -z localhost 3307 2>/dev/null; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
    
    echo ""
}

create_project() {
    local project_name="$1"
    if [ -z "$project_name" ]; then
        echo -e "${RED}❌ Project name is required${NC}"
        echo "Usage: $0 create-project <project_name>"
        exit 1
    fi
    
    local project_dir="./src/$project_name"
    
    if [ -d "$project_dir" ]; then
        echo -e "${YELLOW}⚠️  Project '$project_name' already exists${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📁 Creating project: $project_name${NC}"
    
    mkdir -p "$project_dir"
    
    # Create basic index.php
    cat > "$project_dir/index.php" << EOF
<?php
echo "<h1>Welcome to $project_name</h1>";
echo "<p>Project created at: " . date('Y-m-d H:i:s') . "</p>";
echo "<p>PHP Version: " . PHP_VERSION . "</p>";

// Database connection test
\$host = 'mariadb';
\$dbname = 'lamp_db';
\$username = 'lamp_user';
\$password = 'lamp_pass';

try {
    \$pdo = new PDO("mysql:host=\$host;dbname=\$dbname", \$username, \$password);
    echo "<p style='color: green;'>✅ Database connection successful!</p>";
    
    \$stmt = \$pdo->query('SELECT VERSION() as version');
    \$version = \$stmt->fetch(PDO::FETCH_ASSOC);
    echo "<p>MariaDB Version: " . \$version['version'] . "</p>";
    
} catch(PDOException \$e) {
    echo "<p style='color: red;'>❌ Database connection failed: " . \$e->getMessage() . "</p>";
}
?>
EOF
    
    echo -e "${GREEN}✅ Project '$project_name' created successfully!${NC}"
    echo -e "${BLUE}📍 Location: $project_dir${NC}"
    echo -e "${CYAN}🌐 URL: http://localhost:8090/$project_name/${NC}"
}

case "$1" in
    "start")
        print_banner
        echo -e "${GREEN}🚀 Starting LAMP Stack...${NC}"
        docker-compose up -d
        echo ""
        echo -e "${GREEN}✅ LAMP Stack started successfully!${NC}"
        show_info
        ;;
    "stop")
        echo -e "${YELLOW}⏹️  Stopping LAMP Stack...${NC}"
        docker-compose down
        echo -e "${GREEN}✅ LAMP Stack stopped!${NC}"
        ;;
    "restart")
        echo -e "${YELLOW}🔄 Restarting LAMP Stack...${NC}"
        docker-compose restart
        echo -e "${GREEN}✅ LAMP Stack restarted!${NC}"
        ;;
    "rebuild")
        echo -e "${BLUE}🔨 Rebuilding LAMP Stack...${NC}"
        docker-compose down
        docker-compose up -d --build
        echo -e "${GREEN}✅ LAMP Stack rebuilt!${NC}"
        ;;
    "status")
        echo -e "${BLUE}📊 Container Status:${NC}"
        docker-compose ps
        ;;
    "logs")
        docker-compose logs -f
        ;;
    "logs-apache")
        docker-compose logs -f apache-php
        ;;
    "logs-mariadb")
        docker-compose logs -f mariadb
        ;;
    "shell")
        echo -e "${BLUE}🐚 Accessing Apache container shell...${NC}"
        docker exec -it lamp-apache-php-74 /bin/bash
        ;;
    "mysql")
        echo -e "${BLUE}🗄️  Accessing MariaDB shell...${NC}"
        docker exec -it lamp-mariadb-10-11 mysql -u root -p
        ;;
    "info")
        show_info
        ;;
    "test")
        test_connections
        ;;
    "clean")
        echo -e "${RED}🧹 Cleaning up containers and volumes...${NC}"
        read -p "Are you sure? This will remove all data! (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker-compose down -v
            docker system prune -f
            echo -e "${GREEN}✅ Cleanup completed!${NC}"
        else
            echo -e "${YELLOW}❌ Cleanup cancelled${NC}"
        fi
        ;;
    "create-project")
        create_project "$2"
        ;;
    "hosts")
        echo -e "${CYAN}📝 Add these entries to your /etc/hosts file:${NC}"
        echo ""
        echo "127.0.0.1 logprostyle.local"
        echo "127.0.0.1 lamp.local"
        echo "127.0.0.1 test.local"
        echo ""
        echo -e "${YELLOW}Command to add:${NC}"
        echo "sudo tee -a /etc/hosts << EOF"
        echo "127.0.0.1 logprostyle.local"
        echo "127.0.0.1 lamp.local"
        echo "127.0.0.1 test.local"
        echo "EOF"
        ;;
    *)
        show_usage
        ;;
esac