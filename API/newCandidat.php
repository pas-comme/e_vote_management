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
    $vote = 0.0;
    $req = $conn->query('SELECT * FROM candidats WHERE idPRS = '.$idPRS);

    if($donnees = $req->fetch()){
        echo "candidat(e) déjà présent(e) sur la liste des candidats";
    }
    else{
        $conn->exec('INSERT INTO candidats (idPRS, id_election, vato) VALUES ('.$idPRS.', '.$id_election.', '.$vote.')');
        $requette = $conn->query('SELECT * FROM electeurs WHERE idPRS = '.$idPRS);

        if($donnees = $requette->fetch()){

        }
        else{
            $conn->exec('INSERT INTO electeurs (idPRS, id_election) VALUES ('.$idPRS.', '.$id_election.')');
        }
        echo "candidature réussie";
    }



}
else{
    http_response_code(405);
    echo json_encode(["message" => "méthode invalide"]);
}

?>
