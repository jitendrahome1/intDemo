<?php
$servername = "localhost";
$username = "root";
$password = "test";

// Create connection
/*$conn = new mysqli($servername, $username, $password);
$db=mysql_select_db('userDB');
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully";*/

$con=mysql_connect('localhost','root','test');
$db=mysql_select_db('userDB');
?>