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
        $sql = "SELECT id_may, ten_loai, ten_may, serial_number FROM `checklist_view_onshore`";
        $result = $conn->query($sql);

        if (!$result) {
            die(json_encode(["status" => "error", "message" => "Query failed: " . $conn->error]));
        }
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

    // case 'POST': // Insert a new record
    //     $input = json_decode(file_get_contents('php://input'), true);

    //     $ten_loai = $conn->real_escape_string($input['ten_loai'] ?? '');
    //     $ten_may = $conn->real_escape_string($input['ten_may'] ?? '');
    //     $serial_number = $conn->real_escape_string($input['serial_number'] ?? '');

    //     if ($ten_loai && $ten_may && $serial_number) {
    //         $sql = "INSERT INTO `checklist_may` (ten_loai, ten_may, serial_number) VALUES ('$ten_loai', '$ten_may', '$serial_number')";
    //         if ($conn->query($sql) === TRUE) {
    //             echo json_encode(["status" => "success", "message" => "Record added successfully"]);
    //         } else {
    //             echo json_encode(["status" => "error", "message" => "Insert failed: " . $conn->error]);
    //         }
    //     } else {
    //         echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    //     }
    //     break;
}

$conn->close();
?>