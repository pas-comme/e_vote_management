<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers:, Authorization, X-Requested-Width");

if($_SERVER['REQUEST_METHOD'] == 'PUT'){
    $conn = new PDO('mysql:host=localhost;dbname=vote', 'root', 'toor');

    $id = htmlspecialchars($_GET['id']);
    $statut = 0;

    $req = $conn->query('SELECT * FROM liste WHERE id = '.$id);
    $donnees = $req->fetch();

    if($donnees['statut'] == $statut){
        echo "temps de vote déjà écoulé";
    }
    else{
        $conn->exec('UPDATE liste set statut = '.$statut.' WHERE id = '.$id);
        echo "fin du temps de vote";
    }

}
else{
    http_response_code(405);
    echo "méthode invalide";
}

?>
