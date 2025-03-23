<?php

try {
    $pdo = new PDO('mysql:host=db;port=3306;dbname=laravel10', 'root', 'pass');
    echo "Database connection successful!";
} catch (PDOException $e) {
    echo "Database connection failed: " . $e->getMessage();
}
