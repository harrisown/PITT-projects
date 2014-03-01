<?php
require ("dbinfo.php");
$q=$_GET["q"];
$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
	if ($db_obj->connect_errno) {
	    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
	} else {
	  //print "Connection succesfull -- yay!<br/>\n";
	}
	
	$unsafe_user_input = $q;
	if($stmt = $db_obj->prepare("SELECT * FROM `Transactions` WHERE description LIKE CONCAT('%',?,'%') ORDER BY `Transactions`.`txdate`  DESC")){
		$stmt->bind_param('s', $unsafe_user_input);
		$stmt->execute();
		$stmt->bind_result($id, $date, $account, $subcode, $amount, $description);
	}  
 
print <<<EOHeader
<table border=1> 
<tr><td>Date Posted</td><td>Account Number</td><td>Subcode</td><td>Amount</td><td>Description</td></tr>
EOHeader;
$num_rows = 0;
while($stmt->fetch()){
		$num_rows++;
        $id = $id;
        $date = $date;
        $account =  $account;
        $subcode = $subcode;
        $amount = round($amount,2);
        $description = $description;

print <<<EOText
<tr> <td>$date</td> 
     <td> $account</td>
     <td> $subcode</td>
     <td>$amount</td>
     <td> $description</td>
</tr>
EOText;
}

print <<<EOFooter
</table> 
EOFooter;
		
?>