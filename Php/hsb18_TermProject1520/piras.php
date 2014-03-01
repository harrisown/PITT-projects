<html>
<head>
<h2>Welcome to the piras Database</h2>
<h3>Page brought to you by Harrison Bryant - hsb18@pitt.edu</h3><hr>
</head>
<?php
require ("dbinfo.php");

$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
if ($db_obj->connect_errno) {
    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
} else {
  //print "Connection succesfull -- yay!<br/>\n";
}
?>
<body>
Please select an option:<br>
<a href="resetdb.php">Reset the database!</a>

<form action="import_transactions.php" method="GET">
Please input transactions CSV file to import: <input type = "text" name="transcsv"/>
<input type = "submit" value="Submit"/><br>
</form>
<form action="import_subcodes.php" method="GET">
Please input subcodes CSV file to import: <input type = "text" name="subcsv"/>
<input type = "submit" value="Submit"/>
</form><br>

<a href="maintenance.php">Maintenance!</a><br>
<a href="filter.php">Filter!</a><br>
</body>
</html>