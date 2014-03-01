<?php 
session_start();
require ("dbinfo.php");
//var_dump($_SESSION['account_checked']);
//var_dump($_SESSION['subcode_checked']);
$subcode_array = $_SESSION['subcode_checked'];
$account_array = $_SESSION['account_checked'];
$min = $_GET['min'];
$max = $_GET['max'];
//var_dump($account_array);
$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
	if ($db_obj->connect_errno) {
	    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
	} else {
	  //print "Connection succesfull -- yay!<br/>\n";
	}

$query = "";
$iteration = 0;
foreach ($subcode_array as $key => $value){ 
		if($iteration == 0){
			if($value == "false"){ 
				$query = "SELECT * FROM `Transactions` WHERE subcode NOT LIKE '%$key%'";
				$iteration++;
			}
		}else{
			if($value == "false"){
				$query .= "AND subcode NOT LIKE '%$key%'";
			}
		}
}
foreach ($account_array as $key => $value){ 
		if($iteration == 0){
			if($value == "false"){ 
				$query = "SELECT * FROM `Transactions` WHERE account NOT LIKE '%$key%'";
				$iteration++;
			}
		}else{
			if($value == "false"){
				$query .= "AND account NOT LIKE  '%$key%'";
			}
		}
}
if($query == ""){
	$query ="SELECT * FROM `Transactions` WHERE 1";
}
if($min!="" && $query !=""){
	$query .= " AND amount > '$min'";
}
if($max !="" && $query !=""){
	$query .= " AND amount < '$max'";
}
if($query != ""){
	$query .=" ORDER BY `Transactions`.`txdate`  DESC";
}

//echo $query;
//var_dump($account_array);
//echo $query;
$result = $db_obj->query($query);
	if (!$result) {
   		die("<hr/>The following query: <pre>$query</pre> is invalid: " . $db_obj->error );
	} else {
   
$num_results = $result->num_rows;
print <<<EOHeader
<table border=1> 
<tr><td>Date Posted</td><td>Account Number</td><td>Subcode</td><td>Amount</td><td>Description</td></tr>
EOHeader;

while ($row = mysqli_fetch_assoc($result)) {
        $id = $row['txid'];
        $date = $row['txdate'];
		$account = $row['account'];
		$subcode= $row['subcode'];
		$amount = round($row['amount'],2);
		$description = $row['description'];
		
print <<<EOText
<tr> <td> $date </td> 
     <td> $account</td>
     <td> $subcode</td>
     <td> $amount</td>
     <td> $description</td>
</tr>
EOText;

}
print <<<EOFooter
</table> 
EOFooter;
}
$_SESSION["subcode_checked"] = $subcode_array;
$_SESSION["account_checked"] = $account_array;
?>