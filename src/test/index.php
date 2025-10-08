<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Environment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .card {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            text-align: center;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            background: rgba(255,255,255,0.2);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }
        .btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🧪 Test Environment</h1>
        <p>Testing Apache + PHP + MariaDB Stack</p>
        
        <?php
        echo '<p><strong>PHP Version:</strong> ' . PHP_VERSION . '</p>';
        echo '<p><strong>Server Time:</strong> ' . date('Y-m-d H:i:s') . '</p>';
        
        if (function_exists('apache_get_version')) {
            echo '<p><strong>Apache:</strong> ' . apache_get_version() . '</p>';
        }
        ?>
        
        <div>
            <a href="../" class="btn">🏠 Home</a>
            <a href="../phpinfo.php" class="btn">📋 PHP Info</a>
            <a href="../test-db.php" class="btn">🗄️ Database Test</a>
        </div>
    </div>
</body>
</html>