<?php
require_once 'db.php';

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// Get the request method
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET': // Select from list parameter
        if (isset($_GET['id_danhmuc_checklist']) && is_numeric($_GET['id_danhmuc_checklist'])) {
            $id_danhmuc_checklist = intval($_GET['id_danhmuc_checklist']);
        } else {
            echo json_encode(["status" => "error", "message" => "Invalid or missing id_danhmuc_checklist"]);
            exit;
        }
        $sql = "SELECT * FROM checklist_view_detail_checklist WHERE id_danhmuc_checklist = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id_danhmuc_checklist);
        $stmt->execute();
        $result = $stmt->get_result();

        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }

        if (!empty($data)) {
            echo json_encode(["status" => "success", "data" => $data]);
        } else {
            echo json_encode(["status" => "error", "message" => "No records found for the given id_danhmuc_checklist"]);
        }

        $stmt->close();
        exit;

        break;
    }
$conn->close();
?>
