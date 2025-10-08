<?php
header('Content-Type: application/json');

$response = [
    'timestamp' => date('Y-m-d H:i:s'),
    'php_version' => PHP_VERSION,
    'server_info' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown',
    'database' => null,
    'extensions' => [],
    'environment' => [
        'DB_HOST' => $_ENV['DB_HOST'] ?? 'Not set',
        'DB_DATABASE' => $_ENV['DB_DATABASE'] ?? 'Not set',
        'DB_USERNAME' => $_ENV['DB_USERNAME'] ?? 'Not set'
    ]
];

// Check PHP extensions
$extensions = ['mysqli', 'pdo_mysql', 'gd', 'zip', 'curl', 'mbstring', 'xdebug', 'opcache'];
foreach ($extensions as $ext) {
    $response['extensions'][$ext] = extension_loaded($ext);
}

// Database connection test
try {
    $host = $_ENV['DB_HOST'] ?? 'mariadb';
    $dbname = $_ENV['DB_DATABASE'] ?? 'lamp_db';
    $username = $_ENV['DB_USERNAME'] ?? 'lamp_user';
    $password = $_ENV['DB_PASSWORD'] ?? 'lamp_pass';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Get MariaDB version
    $stmt = $pdo->query('SELECT VERSION() as version');
    $version = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Test table creation and data insertion
    $pdo->exec("CREATE TABLE IF NOT EXISTS test_table (
        id INT AUTO_INCREMENT PRIMARY KEY,
        message TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    $pdo->exec("INSERT INTO test_table (message) VALUES ('Test connection at " . date('Y-m-d H:i:s') . "')");
    
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM test_table");
    $count = $stmt->fetch(PDO::FETCH_ASSOC);
    
    $response['database'] = [
        'status' => 'connected',
        'version' => $version['version'],
        'test_records' => (int)$count['count']
    ];
    
} catch(PDOException $e) {
    $response['database'] = [
        'status' => 'error',
        'message' => $e->getMessage()
    ];
}

echo json_encode($response, JSON_PRETTY_PRINT);
?>