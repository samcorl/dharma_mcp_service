# AWS EC2 Deployment Guide

This guide walks you through deploying the Dharma MCP Service to an AWS EC2 instance.

## Prerequisites

- AWS Account with EC2 access
- AWS CLI configured on your local machine
- SSH key pair for EC2 access
- Domain name (optional, for SSL)

## Step 1: Launch EC2 Instance

### 1.1 Create EC2 Instance
```bash
# Launch Ubuntu 22.04 LTS instance
aws ec2 run-instances \
    --image-id ami-0c7217cdde317cfec \
    --instance-type t3.medium \
    --key-name your-key-pair \
    --security-group-ids sg-xxxxxxxxx \
    --subnet-id subnet-xxxxxxxxx \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=dharma-mcp-server}]'
```

### 1.2 Security Group Configuration
Create or update security group with these rules:

| Type | Protocol | Port | Source | Description |
|------|----------|------|--------|-------------|
| SSH | TCP | 22 | Your IP | SSH access |
| HTTP | TCP | 80 | 0.0.0.0/0 | HTTP traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | HTTPS traffic |
| Custom | TCP | 3000 | 0.0.0.0/0 | Rails app (optional) |

### 1.3 Recommended Instance Types
- **Development/Testing**: t3.small (2 vCPU, 2 GB RAM)
- **Production**: t3.medium (2 vCPU, 4 GB RAM) or larger
- **High Traffic**: c5.large (2 vCPU, 4 GB RAM) or larger

## Step 2: Connect and Setup Server

### 2.1 Connect to Instance
```bash
ssh -i ~/.ssh/your-key.pem ubuntu@your-ec2-public-ip
```

### 2.2 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2.3 Install Docker and Docker Compose
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 2.4 Install Additional Tools
```bash
# Install Git, curl, and other essentials
sudo apt install -y git curl vim htop

# Install AWS CLI (if needed)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## Step 3: Deploy Application

### 3.1 Clone Repository
```bash
cd /home/ubuntu
git clone https://github.com/your-username/dharma_mcp_service.git
cd dharma_mcp_service
```

### 3.2 Configure Environment
```bash
# Copy environment template
cp .env.example .env

# Edit environment variables
vim .env
```

Required environment variables:
```env
# Database Configuration
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_PASSWORD=your_secure_password

# Rails Configuration  
RAILS_MASTER_KEY=your_32_character_master_key
```

### 3.3 Generate Rails Master Key (if needed)
```bash
# If you don't have a master key, generate one
openssl rand -hex 16
```

### 3.4 Deploy Application
```bash
# Make deploy script executable
chmod +x deploy.sh

# Deploy (this will build images, setup database, and start services)
./deploy.sh
```

## Step 4: Configure Domain and SSL (Optional)

### 4.1 Point Domain to EC2
- Create an A record pointing your domain to the EC2 public IP
- Wait for DNS propagation (up to 24 hours)

### 4.2 Setup SSL with Let's Encrypt
```bash
# Install Certbot
sudo apt install -y certbot

# Generate SSL certificate
sudo certbot certonly --standalone -d yourdomain.com

# Copy certificates to nginx directory
sudo mkdir -p /home/ubuntu/dharma_mcp_service/ssl
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem /home/ubuntu/dharma_mcp_service/ssl/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem /home/ubuntu/dharma_mcp_service/ssl/key.pem
sudo chown ubuntu:ubuntu /home/ubuntu/dharma_mcp_service/ssl/*
```

### 4.3 Update Nginx Configuration
Edit `nginx.conf` to use your domain:
```nginx
server_name yourdomain.com;
```

### 4.4 Restart Services
```bash
docker-compose -f docker-compose.production.yml restart
```

## Step 5: Setup Auto-renewal and Monitoring

### 5.1 SSL Certificate Auto-renewal
```bash
# Add cron job for certificate renewal
echo "0 12 * * * /usr/bin/certbot renew --quiet --post-hook 'cd /home/ubuntu/dharma_mcp_service && docker-compose -f docker-compose.production.yml restart nginx'" | sudo crontab -
```

### 5.2 System Monitoring
```bash
# Create monitoring script
cat > /home/ubuntu/monitor.sh << 'EOF'
#!/bin/bash
cd /home/ubuntu/dharma_mcp_service
if ! curl -f http://localhost:3000/up > /dev/null 2>&1; then
    echo "$(date): MCP Service is down, restarting..." >> /var/log/mcp-monitor.log
    docker-compose -f docker-compose.production.yml restart app
fi
EOF

chmod +x /home/ubuntu/monitor.sh

# Add monitoring cron job (check every 5 minutes)
echo "*/5 * * * * /home/ubuntu/monitor.sh" | crontab -
```

## Step 6: Database Backup

### 6.1 Setup Automated Backups
```bash
# Create backup script
cat > /home/ubuntu/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/ubuntu/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

cd /home/ubuntu/dharma_mcp_service
docker-compose -f docker-compose.production.yml exec -T db mysqldump -u root -p$MYSQL_ROOT_PASSWORD dharma_mcp_production > $BACKUP_DIR/backup_$DATE.sql

# Keep only last 7 days of backups
find $BACKUP_DIR -name "backup_*.sql" -mtime +7 -delete
EOF

chmod +x /home/ubuntu/backup.sh

# Add daily backup cron job (2 AM)
echo "0 2 * * * /home/ubuntu/backup.sh" | crontab -
```

## Step 7: Security Hardening

### 7.1 Setup UFW Firewall
```bash
# Enable UFW
sudo ufw --force enable

# Allow specific ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP  
sudo ufw allow 443/tcp   # HTTPS

# Check status
sudo ufw status
```

### 7.2 Disable Password Authentication
```bash
# Edit SSH config
sudo vim /etc/ssh/sshd_config

# Set these values:
# PasswordAuthentication no
# PubkeyAuthentication yes

# Restart SSH
sudo systemctl restart ssh
```

### 7.3 Setup Log Rotation
```bash
# Create logrotate config
sudo tee /etc/logrotate.d/dharma-mcp << 'EOF'
/home/ubuntu/dharma_mcp_service/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 ubuntu ubuntu
    postrotate
        cd /home/ubuntu/dharma_mcp_service && docker-compose -f docker-compose.production.yml restart app
    endscript
}
EOF
```

## Step 8: Testing Deployment

### 8.1 Health Check
```bash
# Test application health
curl http://your-ec2-ip/up

# Test MCP endpoints
curl http://your-ec2-ip/mcp/tools/list
```

### 8.2 Load Testing (Optional)
```bash
# Install Apache Bench
sudo apt install -y apache2-utils

# Basic load test (100 requests, 10 concurrent)
ab -n 100 -c 10 http://your-ec2-ip/mcp/tools/list
```

## Step 9: Maintenance Commands

### 9.1 View Logs
```bash
cd /home/ubuntu/dharma_mcp_service

# View all logs
docker-compose -f docker-compose.production.yml logs

# Follow specific service logs
docker-compose -f docker-compose.production.yml logs -f app
docker-compose -f docker-compose.production.yml logs -f db
docker-compose -f docker-compose.production.yml logs -f nginx
```

### 9.2 Update Application
```bash
cd /home/ubuntu/dharma_mcp_service

# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose -f docker-compose.production.yml down
docker-compose -f docker-compose.production.yml build --no-cache
docker-compose -f docker-compose.production.yml up -d
```

### 9.3 Database Console
```bash
cd /home/ubuntu/dharma_mcp_service

# Connect to MySQL
docker-compose -f docker-compose.production.yml exec db mysql -u dharma_user -p dharma_mcp_production

# Rails console
docker-compose -f docker-compose.production.yml exec app rails console
```

## Troubleshooting

### Common Issues

1. **Port 3000 not accessible**
   - Check security group allows port 3000
   - Verify application is running: `docker ps`

2. **SSL certificate issues**
   - Ensure domain points to correct IP
   - Check certificate files exist in `/ssl/` directory

3. **Database connection errors**
   - Verify MySQL container is running
   - Check environment variables in `.env`

4. **Out of disk space**
   - Clean Docker images: `docker system prune -af`
   - Check log file sizes: `du -sh /var/log/*`

### Performance Tuning

1. **For high traffic, consider:**
   - Application Load Balancer with multiple instances
   - RDS MySQL instead of containerized MySQL
   - ElastiCache for Redis caching
   - CloudFront CDN

2. **Instance optimization:**
   - Monitor CPU/memory with CloudWatch
   - Use GP3 EBS volumes for better I/O
   - Consider reserved instances for cost savings

## Costs Estimation

**Monthly AWS costs (us-east-1):**
- t3.medium: ~$30/month
- EBS storage (20GB): ~$2/month  
- Data transfer: ~$9/GB
- **Total: ~$35-50/month** (depending on traffic)

## Support

For deployment issues:
1. Check application logs
2. Verify all environment variables are set
3. Ensure security groups are configured correctly
4. Review this guide for missed steps

Your MCP server will be available at:
- **HTTP**: http://your-ec2-ip
- **MCP Tools**: http://your-ec2-ip/mcp/tools/list
- **Health Check**: http://your-ec2-ip/up