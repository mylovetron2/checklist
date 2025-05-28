<?php
require_once 'db.php';

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// Get the request method
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST': // Select from list parameter
        $input = json_decode(file_get_contents('php://input'), true);
        //if (isset($input['id_danhmuc_checklist']) && is_numeric($input['id_danhmuc_checklist'])) 
        if (isset($input['id_danhmuc_checklist']))
        {
            $id_danhmuc_checklist = intval($input['id_danhmuc_checklist']);
        } else {
            echo json_encode(["status" => "error", "message" => "Invalid or missing id_danhmuc_checklist", "debug" => ["id_danhmuc_checklist" => $input['id_danhmuc_checklist'],"action" => $input['action']]]);
            exit;
        }
    if (isset($input['action']) && $input['action'] === 'SELECT_INSERT') 
    {
       if (!isset($input['ids']) || is_null($input['ids']) || $input['ids'] === '' || $input['ids'] === '[]')
        {
            $deleteSql = "DELETE FROM checklist_detail_checklist WHERE id_danhmuc_checklist = $id_danhmuc_checklist";
            if ($conn->query($deleteSql) === TRUE) {
                echo json_encode(["status" => "success", "message" => "Records selected and inserted successfully"]);                   
            } else {
                echo json_encode(["status" => "error", "message" => "Error during delete: " . $conn->error]);
                exit;
            }           
        }
        if (isset($input['ids']) && !empty($input['ids'])) 
        {
            $jsonString = $input['ids'];
            $decodedArray = explode(',', trim($jsonString, '[]'));
            // Trim and clean up each element
            $cleanedArray = array_map('trim', $decodedArray);
            
            // Join the array into a comma-separated string for the SQL query
            $ids = implode(',', array_map(function ($item) {
                return "'$item'";
            }, $cleanedArray));

            $selectSql = "SELECT * FROM checklist_danhmuc_may WHERE serial_number IN ($ids)";
            $result = $conn->query($selectSql);

            if ($result->num_rows > 0) {
                $values = [];
                while ($row = $result->fetch_assoc()) {
                    $column1 = $id_danhmuc_checklist;
                    $column2 = $row['id_may'];
                    $column3 = '';
                    $values[] = "('$column1', '$column2', '$column3')";
                }

                if (!empty($values)) {
                    $deleteSql = "DELETE FROM checklist_detail_checklist WHERE id_danhmuc_checklist = $id_danhmuc_checklist";
                    if ($conn->query($deleteSql) === TRUE) {
                        $insertSql = "INSERT INTO checklist_detail_checklist(id_danhmuc_checklist, id_may, remark) VALUES " . implode(", ", $values);
                    } else {
                        echo json_encode(["status" => "error", "message" => "Error during delete: " . $conn->error]);
                        exit;
                    }
                    if ($conn->query($insertSql) === TRUE) {
                        echo json_encode(["status" => "success", "message" => "Records selected and inserted successfully"]);
                    } else {
                        echo json_encode(["status" => "error", "message" => "Error during insert: " . $conn->error]);
                    }
                } else {
                    echo json_encode(["status" => "error", "message" => "No valid data to insert"]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "No records found for the given IDs", "debug" => ["input" =>$input["ids"],"ids" =>$cleanedArray,"id_danhmuc_checklist" =>$id_danhmuc_checklist]]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Invalid or missing IDs"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid action"]);
    
} 
        break;

    
}

$conn->close();
?>
