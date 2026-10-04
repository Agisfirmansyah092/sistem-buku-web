<?php
require __DIR__ . '/auth_common.php';
require __DIR__ . '/../../db.php';

$username = auth_field('username');
$password = auth_field('password', false);
if ($username === '' || $password === '') {
    auth_response(422, false, 'Username dan password wajib diisi.');
}

$statement = $conn->prepare('SELECT id, nama, username, email, password FROM users WHERE username = ? LIMIT 1');
$statement->bind_param('s', $username);
$statement->execute();
$user = $statement->get_result()->fetch_assoc();
if (!$user || !password_verify($password, $user['password'])) {
    auth_response(401, false, 'Username atau password salah. Silakan daftar jika belum memiliki akun.');
}
unset($user['password']);
auth_response(200, true, 'Login berhasil.', ['user' => $user]);
