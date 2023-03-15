<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers:, Authorization, X-Requested-Width");

if($_SERVER['REQUEST_METHOD'] == 'POST'){
    $conn = new PDO('mysql:host=localhost;dbname=vote', 'root', 'toor');

    $nom = htmlspecialchars($_POST['nom']);
    $description = htmlspecialchars($_POST['description']);
    $domaine = htmlspecialchars($_POST['domaine']);

    $conn->exec('INSERT INTO liste (nom, domaine, description) VALUES (\''.$nom.'\', \''.$domaine.'\', \''.$description.'\')');

    echo "insertion éffectuée";

}
else{
    http_response_code(405);
    echo json_encode(["message" => "méthode invalide"]);
}

?>
