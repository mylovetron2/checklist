<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, DELETE');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, Accept, Origin');

$servername = "localhost";
$username = "diavatly";
$password = "cntt2019";
$dbname = "diavatly_quanly";

class   Constants {
    public static $SERVER_NAME = "localhost";
    public static $USER_NAME = "diavatly";
    public static $PASSWORD = "cntt2019";
    public static $DB_NAME = "diavatly_quanly";

    //STATEMENTS
    public static $SELECT_ALL = "SELECT * FROM checklist_danhmuc_checklist";
    public static $INSERT = "INSERT INTO checklist_danhmuc_checklist (date, well, doghouse) VALUES (?,?,?)";
    //public static $INSERT = "INSERT INTO checklist_danhmuc_checklist (date, well, doghouse) VALUES ('2020-01-01', 'well11', 'doghouse11')";
}

?>