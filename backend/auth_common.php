<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

function auth_response($status, $success, $message, $extra = []) {
    http_response_code($status);
    echo json_encode(array_merge(['success' => $success, 'message' => $message], $extra));
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    auth_response(405, false, 'Gunakan metode POST.');
}

function auth_field($key, $trim = true) {
    $value = $_POST[$key] ?? '';
    if (!is_string($value)) {
        auth_response(422, false, 'Format data tidak valid.');
    }
    return $trim ? trim($value) : $value;
}

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
set_exception_handler(function ($error) {
    error_log('Authentication API: ' . $error->getMessage());
    auth_response(500, false, 'Server bermasalah. Coba lagi nanti.');
});
require __DIR__ . '/db.php';
$conn->set_charset('utf8mb4');
