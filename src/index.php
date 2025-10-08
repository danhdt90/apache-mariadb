<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LAMP Stack - Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .status {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
        }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .link-card {
            background: #007bff;
            color: white;
            padding: 15px;
            border-radius: 5px;
            text-decoration: none;
            text-align: center;
            transition: background-color 0.3s;
        }
        .link-card:hover {
            background: #0056b3;
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 LAMP Stack</h1>
            <h2>Apache 2.4 + PHP 7.4 + MariaDB 10.11</h2>
        </div>
        
        <?php
        echo '<div class="status success">✅ PHP is working! Version: ' . PHP_VERSION . '</div>';
        echo '<div class="status info">📅 Current time: ' . date('Y-m-d H:i:s') . '</div>';
        echo '<div class="status info">🌍 Timezone: ' . date_default_timezone_get() . '</div>';
        
        // Check loaded extensions
        $extensions = ['mysqli', 'pdo_mysql', 'gd', 'zip', 'curl', 'mbstring'];
        foreach ($extensions as $ext) {
            if (extension_loaded($ext)) {
                echo "<div class='status success'>✅ Extension $ext is loaded</div>";
            } else {
                echo "<div class='status error'>❌ Extension $ext is NOT loaded</div>";
            }
        }
        
        // Database connection test
        try {
            $host = 'mariadb';
            $dbname = 'lamp_db';
            $username = 'lamp_user';
            $password = 'lamp_pass';
            
            $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            
            $stmt = $pdo->query('SELECT VERSION() as version');
            $version = $stmt->fetch(PDO::FETCH_ASSOC);
            
            echo '<div class="status success">✅ Database connection successful!</div>';
            echo '<div class="status info">🗄️ MariaDB Version: ' . $version['version'] . '</div>';
            
        } catch(PDOException $e) {
            echo '<div class="status error">❌ Database connection failed: ' . $e->getMessage() . '</div>';
        }
        ?>
        
        <div class="links">
            <a href="/phpinfo.php" class="link-card">📋 PHP Info</a>
            <a href="/test-db.php" class="link-card">🗄️ Database Test</a>
            <a href="http://localhost:8082" class="link-card">🔧 phpMyAdmin</a>
            <a href="/test/" class="link-card">🧪 Test Projects</a>
        </div>
        
        <div style="margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 5px;">
            <h3>📁 Quick Links:</h3>
            <ul>
                <li><strong>Local projects:</strong> <code>./src/</code></li>
                <li><strong>Shared projects:</strong> <a href="http://logprostyle.local:8090">LogProStyle</a></li>
                <li><strong>Apache logs:</strong> <code>./logs/apache/</code></li>
                <li><strong>MariaDB port:</strong> <code>localhost:3307</code></li>
            </ul>
        </div>
    </div>
</body>
</html>