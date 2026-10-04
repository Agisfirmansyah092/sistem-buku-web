<?php
require __DIR__ . '/auth_common.php';
require __DIR__ . '/../../db.php';

$nama = auth_field('nama');
$username = auth_field('username');
$email = auth_field('email');
$password = auth_field('password', false);
if ($nama === '' || $username === '' || $email === '' || $password === '') {
    auth_response(422, false, 'Semua data wajib diisi.');
}
if (!preg_match('/^[a-zA-Z0-9_]{3,50}$/D', $username)) {
    auth_response(422, false, 'Username harus 3–50 karakter: huruf, angka, atau underscore.');
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    auth_response(422, false, 'Masukkan alamat email yang valid.');
}
if (mb_strlen($nama) > 100 || strlen($email) > 100) {
    auth_response(422, false, 'Nama dan email maksimal 100 karakter.');
}
if (mb_strlen($password) < 8 || trim($password) === '' || strlen($password) > 72) {
    auth_response(422, false, 'Password minimal 8 karakter, maksimal 72 byte, dan tidak boleh hanya spasi.');
}

$statement = $conn->prepare('SELECT id FROM users WHERE username = ? OR email = ? LIMIT 1');
$statement->bind_param('ss', $username, $email);
$statement->execute();
if ($statement->get_result()->num_rows > 0) {
    auth_response(409, false, 'Username atau email sudah digunakan.');
}

$hash = password_hash($password, PASSWORD_DEFAULT);
$statement = $conn->prepare('INSERT INTO users (nama, username, email, password) VALUES (?, ?, ?, ?)');
$statement->bind_param('ssss', $nama, $username, $email, $hash);
try {
    $statement->execute();
} catch (mysqli_sql_exception $error) {
    if ($error->getCode() === 1062) {
        auth_response(409, false, 'Username atau email sudah digunakan.');
    }
    throw $error;
}
auth_response(200, true, 'Registrasi berhasil. Silakan login.');
