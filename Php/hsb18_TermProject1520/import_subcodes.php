<html>
<head>
<h2>Welcome to the piras Database - Import Subcodes Page</h2>
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

$html = file_get_contents($_GET["subcsv"]);
$lines = explode("\n",$html);
echo "Found ".(count($lines)-1)." entries!<br>";

for($i = 0; $i < count($lines)-1; $i++){
	$line = explode(",",$lines[$i]);
	$code = $line[0];
	$description = $line[1];
	
	
	$query = <<<EOQ
INSERT INTO Subcodes (`subcode`,`description`) VALUES ($code,"$description")
EOQ;
	
	$result = $db_obj->query($query);
	if (!$result) {
   		die("<hr/>The following query: <pre>$query</pre> is invalid: " . $db_obj->error );
	}else{
		//echo "successful entry!<br>";
	}
}
echo "<br>all data entered!<br>";
?>
<body>
<a href="piras.php">Return to Piras</a>
</body>
</html>