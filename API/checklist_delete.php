<?php
require_once 'db.php';


// if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
//     header('Access-Control-Allow-Origin: *');
//     header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
//     header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, Accept, Origin');
//     http_response_code(200);
//     exit();
// }

$input = json_decode(file_get_contents('php://input'), true);
$checklist_id = $input['checklist_id'];

$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8mb4");
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST': // delete
        $sql = "DELETE FROM checklist_danhmuc_checklist WHERE id_danhmuc_checklist = '$checklist_id'";
        $result = $conn->query($sql);

        if ($result) {
            if ($conn->affected_rows > 0) {
                echo json_encode(["status" => "success", "message" => "Deleted successfully"]);
            } else {
                echo json_encode(["status" => "error", "message" => "No record deleted"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Delete failed: " . $conn->error]);
        }
        break;
}
$conn->close();
?>