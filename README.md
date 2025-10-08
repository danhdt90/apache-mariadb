# LAMP Stack - Apache + MariaDB

Modern LAMP stack với Apache 2.4, PHP 7.4, và MariaDB 10.11 chạy trong Docker containers.

## 🚀 Quick Start

```bash
# 1. Khởi động LAMP stack
./lamp-control.sh start

# 2. Thêm domains vào hosts file
sudo tee -a /etc/hosts << EOF
127.0.0.1 logprostyle.local
127.0.0.1 lamp.local
127.0.0.1 test.local
EOF

# 3. Truy cập ứng dụng
open http://localhost:8090
```

## 📊 Access URLs

| Service | URL | Description |
|---------|-----|-------------|
| **Apache** | http://localhost:8090 | Main web server |
| **phpMyAdmin** | http://localhost:8082 | Database admin |
| **LogProStyle** | http://logprostyle.local:8090 | Shared WordPress project |
| **Local Projects** | http://lamp.local:8090 | Local development |
| **Test Environment** | http://test.local:8090 | Testing area |
| **HTTPS** | https://localhost:8443 | SSL enabled |

## 🗄️ Database Connection

```php
$host = 'mariadb';  // or localhost:3307 from host
$dbname = 'lamp_db';
$username = 'lamp_user';
$password = 'lamp_pass';
$root_password = 'passrootDanh123@';
```

## 📁 Directory Structure

```
lamp-apache-mariadb/
├── docker-compose.yml          # Docker services
├── .env                        # Environment variables
├── lamp-control.sh             # Control script
├── docker/apache-php/          # Apache + PHP container
│   ├── Dockerfile
│   ├── apache.conf
│   ├── php.ini
│   └── xdebug.ini
├── config/                     # Configuration files
│   ├── apache/
│   ├── mariadb/
│   └── php/
├── logs/                       # Log files
│   └── apache/
└── src/                        # Your projects
    ├── index.php               # Welcome page
    ├── phpinfo.php             # PHP information
    ├── test-db.php             # Database test
    └── test/                   # Test environment
```

## 🛠️ Control Script Commands

```bash
# Main operations
./lamp-control.sh start         # Start containers
./lamp-control.sh stop          # Stop containers
./lamp-control.sh restart       # Restart containers
./lamp-control.sh rebuild       # Rebuild containers

# Monitoring
./lamp-control.sh status        # Container status
./lamp-control.sh logs          # View all logs
./lamp-control.sh test          # Test connections

# Utilities
./lamp-control.sh shell         # Access container shell
./lamp-control.sh mysql         # Access MariaDB shell
./lamp-control.sh info          # Show system info
./lamp-control.sh hosts         # Show hosts entries

# Project management
./lamp-control.sh create-project myapp  # Create new project
```

## 🔧 Features

### Apache 2.4
- ✅ Multiple virtual hosts
- ✅ SSL/HTTPS support
- ✅ Mod rewrite enabled
- ✅ Security headers
- ✅ Compression (gzip)

### PHP 7.4
- ✅ All common extensions
- ✅ Xdebug for debugging
- ✅ OPcache for performance
- ✅ Composer installed
- ✅ WP-CLI for WordPress

### MariaDB 10.11
- ✅ UTF8MB4 charset
- ✅ Performance optimized
- ✅ Slow query logging
- ✅ Custom configuration

### Development Tools
- ✅ phpMyAdmin
- ✅ Log monitoring
- ✅ Health checks
- ✅ Project templates

## 🎯 Creating New Projects

```bash
# Method 1: Using control script
./lamp-control.sh create-project myapp

# Method 2: Manual
mkdir src/myapp
echo "<?php echo 'Hello World!'; ?>" > src/myapp/index.php
```

Access your project at: http://localhost:8090/myapp/

## 🔍 Debugging

### Xdebug Configuration
- **IDE Key:** `VSCODE_LAMP`
- **Port:** `9004`
- **Host:** `host.docker.internal`

### VS Code Launch Configuration
```json
{
    "name": "Listen for Xdebug (LAMP)",
    "type": "php",
    "request": "launch",
    "port": 9004,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}/src"
    }
}
```

## 📋 Log Files

```bash
# Apache logs
tail -f logs/apache/access.log
tail -f logs/apache/error.log

# Container logs
docker-compose logs -f apache-php
docker-compose logs -f mariadb
```

## 🧪 Testing

### Health Check
```bash
./lamp-control.sh test
```

### Manual Tests
```bash
# Test Apache
curl http://localhost:8090

# Test PHP
curl http://localhost:8090/phpinfo.php

# Test Database
curl http://localhost:8090/test-db.php
```

## 🔧 Troubleshooting

### Common Issues

1. **Port conflicts**
   ```bash
   # Check if ports are in use
   netstat -tlnp | grep -E ':(8090|8082|3307)'
   ```

2. **Permission issues**
   ```bash
   # Fix permissions
   sudo chown -R $USER:$USER src/
   chmod -R 755 src/
   ```

3. **Database connection fails**
   ```bash
   # Check MariaDB logs
   ./lamp-control.sh logs-mariadb
   ```

### Reset Everything
```bash
./lamp-control.sh clean    # ⚠️  Removes all data!
```

## 🚀 Performance Tips

1. **OPcache** is enabled by default
2. **MariaDB** is tuned for development
3. **Compression** is enabled for static files
4. **Realpath cache** improves file access

## 📦 Extensions Included

- **Database:** mysqli, pdo_mysql
- **Graphics:** gd, imagick
- **Archives:** zip
- **Networking:** curl
- **Strings:** mbstring
- **Development:** xdebug
- **Performance:** opcache
- **Internationalization:** intl
- **Web Services:** soap
- **Caching:** redis

## 🤝 Integration

### Shared Projects
The setup automatically mounts the main LAMP-docker project at `/var/www/shared/`, allowing access to existing projects like LogProStyle.

### Multiple Environments
You can run this alongside the original Nginx + MySQL setup without conflicts:
- **Original:** ports 80, 3306, 8081
- **LAMP:** ports 8090, 3307, 8082

---

**🎉 Happy coding with your new LAMP stack!**