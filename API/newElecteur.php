<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers:, Authorization, X-Requested-Width");

if($_SERVER['REQUEST_METHOD'] == 'POST'){
    $conn = new PDO('mysql:host=localhost;dbname=vote', 'root', 'toor');

    $idPRS = (int) htmlspecialchars($_POST['idPRS']);
    $id_election = (int) htmlspecialchars($_POST['id_election']);
    $req = $conn->query('SELECT * FROM electeurs WHERE idPRS = '.$idPRS);

    if($donnees = $req->fetch()){
        echo "electeur déjà présente sur la liste des electeurs";
    }
    else{
        $conn->exec('INSERT INTO electeurs (idPRS, id_election) VALUES ('.$idPRS.', '.$id_election.')');
        echo "electeur ajouté";
    }
}
else{
    http_response_code(405);
    echo json_encode(["message" => "méthode invalide"]);
}

?>
