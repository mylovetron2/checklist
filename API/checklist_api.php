<?php

class   Constants {
    public static $SERVER_NAME = "localhost";
    public static $USER_NAME = "root";
    public static $PASSWORD = "";
    public static $DB_NAME = "diavatly_quanly";

    //STATEMENTS
    public static $SELECT_ALL = "SELECT * FROM checklist_danhmuc_checklist";
}

class checklist {
    // public $id;
    // public $name;
    // public $description;
    // public $image;
    // public $date;

    // public function __construct($id, $name, $description, $image, $date) {
    //     $this->id = $id;
    //     $this->name = $name;
    //     $this->description = $description;
    //     $this->image = $image;
    //     $this->date = $date;
    // }
    public function connect() {
        $conn = new mysqli(Constants::$SERVER_NAME, Constants::$USER_NAME, Constants::$PASSWORD, Constants::$DB_NAME);
        if ($conn->connect_error) {
            return null;
        } else {
            return $conn;
        }
    }
    
    public function select() {
        $conn = $this->connect();
        if ($conn == null) {
            return null;
        }

        $result = $conn->query(Constants::$SELECT_ALL);
        $checklists = array();

        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $checklist = new checklist($row["id_danhmuc_checklist"], $row["date"], $row["well"], $row["doghouse"]);
                array_push($checklists, $checklist);
            }
            print(json_encode(array_reverse($checklists)));
        }
        else {
            print(json_encode(array("PHP EXCEPTION : CAN'T GET DATA FROM MYSQL. ")));
        }


        $conn->close();
        return $checklists;
    }
        
}

$checklist = new checklist();
$checklist->select();