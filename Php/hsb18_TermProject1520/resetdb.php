<html>
<head>
<h2>Welcome to the piras Database - Reset Page</h2>
<h3>Page brought to you by Harrison Bryant - hsb18@pitt.edu</h3><hr>
</head>
<?php
require("dbinfo.php");
$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
if ($db_obj->connect_errno) {
    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
} else {
  //print "Connection succesfull -- yay!<br/>\n";
}

$query = <<<EOQ
DELETE FROM `Subcodes` WHERE 1
EOQ;
$result = $db_obj->query($query);
if (!$result) {
   	die("<hr/>The following query: <pre>$query</pre> is invalid: " . $db_obj->error );
} else{
	echo "Subcodes data deleted!\n";
}
$query = <<<EOQ
DELETE FROM `Transactions` WHERE 1
EOQ;
$result = $db_obj->query($query);
if (!$result) {
   	die("<hr/>The following query: <pre>$query</pre> is invalid: " . $db_obj->error );
} else{
	echo "Transactions data deleted!\n";
}
?>
<body>
<br>
<a href="piras.php">Return to Piras</a>
</body>
</html>