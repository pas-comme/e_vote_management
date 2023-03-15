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
    $id_candidat = (int) htmlspecialchars($_POST['id_candidat']);
    $requette = $conn->query('SELECT * FROM electeurs WHERE id_election = '.$id_election.' && idPRS = '.$idPRS);
    $reponse =  $requette->fetch();
    if( $reponse['vote'] == 1){
        echo "vous ne pouvez plus voter pour cette éléction car vous avez déjà voté";
    }
    else{
    $conn->exec('UPDATE electeurs SET vote = 1 WHERE id_election='.$id_election.' && idPRS = '.$idPRS);
    $req = $conn->query('SELECT * FROM candidats  WHERE id_election='.$id_election.' && idPRS = '.$id_candidat);
    $response =  $req->fetch();
    $vato = $response['vato'] + 1;
    $conn->exec('UPDATE candidats SET vato = '.$vato.' WHERE id_election='.$id_election.' && idPRS = '.$id_candidat);
    echo "vote effectué";
    }
}
else{
    http_response_code(405);
    echo "méthode invalide";
}


?>
