<?php

$key = '12345678901234567890123456789012'; // 32 caracteres
$iv = '1234567890123456'; // 16 caracteres

function decrypt($cipherText) {
    global $key, $iv;
    $cipherText = base64_decode($cipherText);
    $decrypted = openssl_decrypt($cipherText, 'AES-256-CBC', $key, OPENSSL_RAW_DATA, $iv);
    return $decrypted;
}

function encrypt($plainText) {
    global $key, $iv;
    $encrypted = openssl_encrypt($plainText, 'AES-256-CBC', $key, OPENSSL_RAW_DATA, $iv);
    return base64_encode($encrypted);
}

?>