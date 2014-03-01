<?php
require ("dbinfo.php");
$date =$_GET["date"];
$account =$_GET["account"];
$subcode = $_GET["subcode"];
$amount = $_GET["amount"];
$description = $_GET["description"];

$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
	if ($db_obj->connect_errno) {
	    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
	} else {
	  //print "Connection succesfull -- yay!<br/>\n";
	}
	$query = <<<EOQ
INSERT INTO `Transactions` (txdate,account,subcode,amount,description) VALUES ("$date","$account",$subcode,$amount,"$description")
EOQ;
$result = $db_obj->query($query);
	if (!$result) {
   		die("<hr/>The following query: <pre>$query</pre> is invalid: " . $db_obj->error );
	} else {
		//echo "updated!";
	}
//echo $query;
$query = <<<EOQ
SELECT * FROM `Transactions` ORDER BY `Transactions`.`txdate`  DESC
EOQ;
$result = $db_obj->query($query);
	if (!$result) {
   		die("<hr/>The following query: <pre>$query</pre> is invalid: " . $db_obj->error );
	} else {
   
print <<<EOHeader
<div id="trans_table">
<table border=1> 
<tr><td>Delete</td><td>Update</td><td>Date Entered</td><td>Account Number</td><td>Subcode</td><td>Amount</td><td>Description</td></tr>
EOHeader;

$account_array = array();
$subcode_array = array();
$iteration = 0;
while ($row = mysqli_fetch_assoc($result)) {
        $id = $row['txid'];
        $date = $row['txdate'];
		$account = $row['account'];
		$subcode= $row['subcode'];
		$amount = round($row['amount'],2);
		$description = $row['description'];
		
		if(array_key_exists("$account",$account_array)){
			$account_array["$account"] += 1;
		}else{
			$account_array["$account"] = 1;
		}
		if(array_key_exists("$subcode",$subcode_array)){
			$subcode_array["$subcode"] += 1;
		}else{
			$subcode_array["$subcode"] = 1;
		}
		
print <<<EOText
<tr class="$iteration">

	 <td><button id="$id" name="$iteration" onClick="rowdel(this.id)">X</button></td>
	 <td><button id="$id" name="$iteration" onClick="rowupdate(this)">^</button></td>
	 <td class="$iteration"> $date </td>
     <td class="$iteration"> $account</td>
     <td class="$iteration"> $subcode</td>
     <td class="$iteration"> $amount</td>
     <td class="$iteration"> $description</td>
</tr>
EOText;
$iteration++;
}
print <<<EOFooter
</table>
</div>
EOFooter;
}
?>

</body>
</html>