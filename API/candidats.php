<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers:, Authorization, X-Requested-Width");
if($_SERVER['REQUEST_METHOD'] == 'GET'){
    $bdd= new PDO('mysql:host=localhost;dbname=vote', 'root', 'toor');
    $id = htmlspecialchars($_GET['id']);
    $req = $bdd->query('SELECT * FROM candidats  WHERE id_election = '.$id);
        $tableau = [];
        while($row = $req->fetch(PDO::FETCH_ASSOC)){
            extract($row);
            $prod = [
                "id" => (int) $id,
                "idPRS" => (int) $idPRS,
                "id_election" => (int) $id_election,
                "vato" => (Double) $vato
            ];
            $tableau [] = $prod;
        }

        echo json_encode($tableau);

}
else{
    http_response_code(405);
    echo json_encode(["message" => "méthode invalide"]);
}




?>
