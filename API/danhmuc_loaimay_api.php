<?php

require_once 'db.php';

header('Access-Control-Allow-Origin: *');

header('Access-Control-Allow-Methods: GET, POST');

header("Access-Control-Allow-Headers: X-Requested-With");


// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8mb4");

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// Get the request method
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET': // Select all records
        $sql = "SELECT id_loai_may,ten_loai FROM `checklist_loai_maygieng`";
        $result = $conn->query($sql);

        if (!$result) {
            die(json_encode(["status" => "error", "message" => "Query failed: " . $conn->error]));
        }
        $data1 = [];
        while ($row = $result->fetch_assoc()) {
            $data1[] = $row;
        }

        if (!empty($data1)) {
            echo json_encode(["status" => "success", "data" => $data1]);
        } else {
            echo json_encode(["status" => "error", "message" => "No records found"]);
        }
        break;

      
    
}

$conn->close();
?>
