<?php
    //require_once 'checklist_api.php';
    require_once 'db.php';

    $input = json_decode(file_get_contents('php://input'), true);
    $date = $input['date'];
    $date = date('Y-m-d', strtotime($date));
	$well = $input['well'];
	$doghouse = $input['doghouse'];

    // $date = $_GET['date'];
    // $date = date('Y-m-d', strtotime($date));
	// $well = $_GET['well'];
	// $doghouse = $_GET['doghouse'];
	
    $conn = new mysqli($servername, $username, $password, $dbname);
    $conn->set_charset("utf8mb4");
    // Check connection
    if ($conn->connect_error) {
        die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
    }

    // Get the request method
    $method = $_SERVER['REQUEST_METHOD'];

    switch ($method) {
        case 'POST': // Insert new record
            $sql = "INSERT INTO checklist_danhmuc_checklist (date, well, doghouse) VALUES ('$date', '$well', '$doghouse')";
            //$sql = "INSERT INTO checklist_danhmuc_checklist (date, well, doghouse) VALUES ('2023-01-01', 'well', 'doghouse')";
            $result = $conn->query($sql);
            if ($result) {
                echo json_encode(["status" => "success", "message" => "Record added successfully"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Insert failed: " . $conn->error]);
            }

            break;
             
        }
?>



