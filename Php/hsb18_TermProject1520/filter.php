<?php session_start();
?>
<html>
<head>
<h2>Welcome to the Piras Database - Filter Page</h2>
<h3>Page brought to you by Harrison Bryant - hsb18@pitt.edu</h3>
<h4><a href="piras.php">Return to Piras main page</a></h4><hr>
</head>
<script>
function reset(){
checkboxes = document.querySelectorAll('input[type=checkbox]');
document.getElementById('minval').value = "";
max = document.getElementById('maxval').value = "";
document.getElementById('descFilter').value = "";
for(i = 0; i < checkboxes.length;i++){
	checkboxes[i].checked = true;
}
filter();


}
function filter(){
	accountcheckboxes = document.querySelectorAll('input[name=account]');
	subcodecheckboxes = document.getElementsByName("subcode");
	
	for (i = 0; i < accountcheckboxes.length; i++) {
	var xmlhttp;

	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else{// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function(){
  		if (xmlhttp.readyState==4 && xmlhttp.status==200){
  			document.getElementById("trans_table").innerHTML=xmlhttp.responseText;
		}
	}
		var str = accountcheckboxes[i].value;
		var checked = accountcheckboxes[i].checked;
		//alert(str+" "+checked);
		xmlhttp.open("GET","accntADD.php?q="+str+"&c="+checked,true);
		xmlhttp.send();
    }
    for (i = 0; i < subcodecheckboxes.length; i++) {
	var xmlhttp;

	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else{// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function(){
  		if (xmlhttp.readyState==4 && xmlhttp.status==200){
  			document.getElementById("trans_table").innerHTML=xmlhttp.responseText;
		}
	}
		var str = subcodecheckboxes[i].value;
		var checked = subcodecheckboxes[i].checked;
		//alert(str+" "+checked);
		xmlhttp.open("GET","subADD.php?q="+str+"&c="+checked,true);
		xmlhttp.send();
    }
    var xmlhttp;
	var min = document.getElementById("minval").value;
	var max = document.getElementById("maxval").value;
	
	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else{// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function(){
  		if (xmlhttp.readyState==4 && xmlhttp.status==200){
  			document.getElementById("trans_table").innerHTML=xmlhttp.responseText;
		}
	}
    xmlhttp.open("GET","filterall.php?min="+min+"&max="+max,true);
    xmlhttp.send();
    
}


function showHint(str){
	var xmlhttp;
	if (str.length==0){ 
	  
	}
	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else{// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function(){
  		if (xmlhttp.readyState==4 && xmlhttp.status==200){
  			document.getElementById("trans_table").innerHTML=xmlhttp.responseText;
		}
	}
	xmlhttp.open("GET","filterDesc.php?q="+str,true);
	xmlhttp.send();
}
</script>
<?php
$account_checked = array();
$subcode_checked = array();
$account_array = array("something" => 0);
$subcode_array = array("something" => 0);
require ("dbinfo.php");
$db_obj = new mysqli("localhost", $db_user, $db_pass, $db_name);
if ($db_obj->connect_errno) {
    die("<hr/>Failed to connect to MySQL: " . $db_obj->connect_error);
} else {
  //print "Connection succesfull -- yay!<br/>\n";
}
?>
<body>
<?php
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
<tr><td>Date Entered</td><td>Account Number</td><td>Subcode</td><td>Amount</td><td>Description</td></tr>
EOHeader;


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
</div>
EOFooter;
}
echo "<hr>";

//var_dump($account_array);
//var_dump($subcode_array);
?>
<form action=""> 
Filter String: <input type="text" id="descFilter" onkeyup="showHint(this.value)"/>
</form>
	<?php
	echo " ";
	foreach ($account_array as $key => $value){ 
		if($value > 0){
		?>
		<input type="checkbox" name="account" checked="true" value="<?php echo $key; ?>" name ="<?php echo $key; ?>"><?php echo $key; ?>
		
<?php  
		}
	}
	 ?>	
	<?php 
	echo " ";
	foreach ($subcode_array as $key => $value){ 
		if($value > 0){ 
		?>
		<input type="checkbox" name="subcode" checked= "true" value="<?php echo $key; ?>" name ="<?php echo $key; ?>"><?php echo $key; ?>
		
<?php  
		}
	}
$_SESSION["account_checked"] = $account_checked;
$_SESSION["subcode_checked"] = $subcode_checked;
?>
<br>
Min: <input type="text" id="minval"/>
Max: <input type="text" id="maxval"/>
<button type="button" onclick="filter()">Filter!</button>
<button type="button" onclick="reset()">Reset Parameters!</button>
</body>
</html>