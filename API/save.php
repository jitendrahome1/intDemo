<?php

include 'connection.php';

 $name =  $_POST["name"];
 $email =  $_POST["email"];
 $password =  $_POST["password"];


$sql = 'INSERT INTO userDetails(userName,email,password) VALUES ("'.$name.'", "'.$email.'","'.$password.'")';
      
   
   $retval = mysql_query( $sql);
 if(! $retval ) {
      die('Could not enter data: ' . mysql_error());
   }
   
   echo "Entered data successfully\n";

?>