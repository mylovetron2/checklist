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
        $sql = "SELECT * FROM checklist_danhmuc_checklist";
        $result = $conn->query($sql);

        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }

        if (!empty($data)) {
            echo json_encode(["status" => "success", "data" => $data]);
        } else {
            echo json_encode(["status" => "error", "message" => "No records found"]);
        }
        break;

      
    
}

$conn->close();
?>

