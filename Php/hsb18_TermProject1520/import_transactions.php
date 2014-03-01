<html>
<head>
<h2>Welcome to the piras Database - Import Transactions Page</h2>
<h3>Page brought to you by Harrison Bryant - hsb18@pitt.edu</h3><hr>
</head>
<?php
require ("dbinfo.php");

$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
if ($db_obj->connect_errno) {
    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
}

$html = file_get_contents($_GET["transcsv"]);
//echo $html;
$lines = explode("\n",$html);
echo "Found ".(count($lines)-1)." entries!<br>";

for($i = 0; $i < count($lines)-1; $i++){
	$line = explode(",",$lines[$i]);
	$number = $line[0];
	$date = $line[1];
	$account = $line[2];
	$subcode = $line[3];
	$amount = $line[4];
	$description = $line[5];
	
	$query = <<<EOQ
INSERT INTO Transactions (`txdate`,`account`, `subcode`,`amount`,`description`) VALUES ("$date","$account",$subcode,$amount,"$description")
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