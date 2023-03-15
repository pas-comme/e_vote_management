<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers:, Authorization, X-Requested-Width");

if($_SERVER['REQUEST_METHOD'] == 'PUT'){
    $conn = new PDO('mysql:host=localhost;dbname=vote', 'root', 'toor');

    $id = htmlspecialchars($_GET['id']);
    $conn->exec('UPDATE liste set maj = 0 WHERE id = '.$id);

    echo "éléction archivé";

}
else{
    http_response_code(405);
    echo "méthode invalide";
}

?>
