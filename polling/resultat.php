<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers:, Authorization, X-Requested-Width");
if($_SERVER['REQUEST_METHOD'] == 'GET'){
    $conn = new PDO('mysql:host=localhost;dbname=vote', 'root', 'toor');
    $id = htmlspecialchars($_GET['id']);
    //$id = 1;
    $statut = (bool) 1;
    $election_status = "";

    // nombre d'élécteurs
    $requette = $conn->query('SELECT id FROM electeurs WHERE id_election = '.$id.' ORDER BY id DESC LIMIT 1');
    $reponse =  $requette->fetch();

    $nbr_electeur = $reponse['id'];


    $temp = $conn->query('SELECT * FROM liste WHERE id = '.$id);

    $donnees = $temp->fetch();

    if($donnees['statut'] == $statut){
        $election_status = "lancée";
    }
    else{
         $election_status = "fin";
    }

    // nombre de participation
    $nbr_participation = 0.0;
    $req = $conn->query('SELECT * FROM candidats  WHERE id_election = '.$id);

        while($row = $req->fetch(PDO::FETCH_ASSOC)){
            extract($row);
            $prod = [
                "id" => (int) $id,
                "idPRS" => (int) $idPRS,
                "id_election" => (int) $id_election,
                "vato" => (Double) $vato
            ];
            $nbr_participation += $prod['vato'];
        }
        echo json_encode([(Double) $nbr_electeur, $election_status, (Double) $nbr_participation]);

}
else{
    http_response_code(405);
    echo json_encode(["message" => "méthode invalide"]);
}




?>
