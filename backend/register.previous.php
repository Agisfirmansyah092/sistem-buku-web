<?php

header("Content-Type: application/json");
include "db.php";

$nama = $_POST['nama'] ?? '';
$username = $_POST['username'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if (
    empty($nama) ||
    empty($username) ||
    empty($email) ||
    empty($password)
) {
    echo json_encode([
        "success" => false,
        "message" => "Semua data wajib diisi"
    ]);
    exit;
}

$cek = mysqli_query(
    $conn,
    "SELECT * FROM users 
     WHERE username='$username' OR email='$email'"
);

if (mysqli_num_rows($cek) > 0) {
    echo json_encode([
        "success" => false,
        "message" => "Username atau email sudah digunakan"
    ]);
    exit;
}

$passwordHash = password_hash($password, PASSWORD_DEFAULT);

$query = mysqli_query(
    $conn,
    "INSERT INTO users (nama, username, email, password)
     VALUES ('$nama', '$username', '$email', '$passwordHash')"
);

if ($query) {
    echo json_encode([
        "success" => true,
        "message" => "Registrasi berhasil"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Registrasi gagal"
    ]);
}

?>