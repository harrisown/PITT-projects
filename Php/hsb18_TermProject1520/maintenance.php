<?php session_start();?>
<html>
<head>
<h2>Welcome to the Piras Database - Maintenance Page</h2>
<h3>Page brought to you by Harrison Bryant - hsb18@pitt.edu</h3>
<h4><a href="piras.php">Return to Piras main page</a></h4><hr>
</head>
<script>
function savenew(button){
	var boxes = document.getElementsByName("newerBox");
	var date = boxes[0].value;
	var account = boxes[1].value;
	var subcode = boxes[2].value;
	var amount = boxes[3].value;
	var description = boxes[4].value;
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
    xmlhttp.open("GET","insert.php?date="+date+"&account="+account+"&subcode="+subcode+"&amount="+amount+"&description="+description,true);
    xmlhttp.send();


}
function add(){
var row = document.getElementsByName("mainTable")[0].insertRow(1);
row.innerHTML += '<tr id="0">';
row.innerHTML += '<td></td><td></td>';
row.innerHTML += '<td><input type="text" name ="newerBox" id="rowid" value=""></td>';
row.innerHTML += '<td><input type="text" name ="newerBox" id="rowid" value=""></td>';
row.innerHTML += '<td><input type="text" name ="newerBox" id="rowid" value=""></td>';
row.innerHTML += '<td><input type="text" name ="newerBox" id="rowid" value=""></td>';
row.innerHTML += '<td><input type="text" name ="newerBox" id="rowid" value=""></td>';
row.innerHTML += '</tr>';
	
	var savebtn=document.createElement("BUTTON");
	var savetext=document.createTextNode("Save");
	savebtn.appendChild(savetext);
	savebtn.setAttribute("name",1);
	savebtn.setAttribute("onClick","savenew(this)");
	var canbtn=document.createElement("BUTTON");
	var cantext=document.createTextNode("Cancel");
	canbtn.appendChild(cantext);
	canbtn.setAttribute("name","canButton");
	canbtn.setAttribute("onClick","cancel()");
	row.appendChild(savebtn);
	row.appendChild(canbtn);
	


}
function ArrNoDupe(a) {
    var temp = {};
    for (var i = 0; i < a.length; i++)
        temp[a[i]] = true;
    var r = [];
    for (var k in temp)
        r.push(k);
    return r;
}
function rowupdate(button){
	var subs = document.getElementsByName("sub");
	var subarray = [];
	for(i = 0; i < subs.length;i++){
		subarray[i] = subs[i].innerHTML;
	}
	console.log(subarray);
	subcodearray = ArrNoDupe(subarray);
	console.log(subcodearray);
	var rownum = button.name;
	var rowid = button.id;
	var vrows = document.getElementsByClassName(rownum);
	for(i = 0; i < vrows.length; i++){
		vrows[i].innerHTML = "<input type='text' name ='newBox' id='rowid' value=''>"
	}
	//var rownum = document.getElementById(currow);
	vrows[2].innerHTML = "";
	var select = document.createElement("select");
	select.setAttribute("name", "mySelect");
   	select.setAttribute("id", "mySelect");
	select.style.width = "300px";
	for(i = 0; i < subcodearray.length;i++){
		var option;
		option = document.createElement("option");
  		option.setAttribute("value", subcodearray[i]);
  		option.innerHTML = subcodearray[i];
  		select.appendChild(option);
  	}
  	vrows[2].appendChild(select);
	var date = vrows[0].value;
	var account = vrows[1].value;
	
	var amount = vrows[3].value;
	var description = vrows[4].value;
	var savebtn=document.createElement("BUTTON");
	var savetext=document.createTextNode("Save");
	savebtn.appendChild(savetext);
	savebtn.setAttribute("name",rowid);
	savebtn.setAttribute("onClick","toSave(this)");
	var canbtn=document.createElement("BUTTON");
	var cantext=document.createTextNode("Cancel");
	canbtn.appendChild(cantext);
	canbtn.setAttribute("name","canButton");
	canbtn.setAttribute("onClick","cancel()");
	document.getElementById(rownum).appendChild(savebtn);
	document.getElementById(rownum).appendChild(canbtn);
	
	
}
function rowdel(number){
	
	var xmlhttp;
	var row_id = number;

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
	var r=confirm("Are you sure you want to delete?");
	if (r==true){
		xmlhttp.open("GET","rowdel.php?id="+row_id,true);
    	xmlhttp.send();
  	}else{
  		
  	}
    
}
function toSave(button){
	var boxes = document.getElementsByName("newBox");
	var date = boxes[0].value;
	var account = boxes[1].value;
	var e = document.getElementById("mySelect");
	var subcode = e.options[e.selectedIndex].value;
	var amount = boxes[2].value;
	var description = boxes[3].value;
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
    xmlhttp.open("GET","update.php?id="+button.name+"&date="+date+"&account="+account+"&subcode="+subcode+"&amount="+amount+"&description="+description,true);
    xmlhttp.send();

	
}
function cancel(){
	var xmlhttp;
	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else{// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function(){
  		if (xmlhttp.readyState==4 && xmlhttp.status==200){
  			document.getElementsByTagName("html")[0].innerHTML=xmlhttp.responseText;
		}
	}
    xmlhttp.open("GET","maintenance.php",true);
    xmlhttp.send();
}

</script>
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
<button type="button" onClick="add()">Add Transaction</button><br>
<table border=1 name="mainTable"> 
<tr><td>Delete</td><td>Update</td><td>Date Entered</td><td>Account Number</td><td>Subcode</td><td>Amount</td><td>Description</td></tr>
EOHeader;

$iteration = 0;
$account_array = array();
$subcode_array = array();
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
$subsize = sizeof($subcode_array);
print <<<EOText
<tr id="$iteration">
	 <td><button id="$id" name="$iteration" onClick="rowdel(this.id)">X</button></td>
	 <td><button id="$id" name="$iteration" onClick="rowupdate(this)">^</button></td>
	 <td class="$iteration"> $date </td>
     <td class="$iteration"> $account</td>
     <td class="$iteration" name ="sub"> $subcode</td>
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
echo "<hr>";
?>

</body>
</html>