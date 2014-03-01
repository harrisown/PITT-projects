<?php session_start();
$q=$_GET["q"];
$c = $_GET["c"];
$subcode_array = $_SESSION["subcode_checked"];
$subcode_array[$q] = $c;
$_SESSION["subcode_checked"] = $subcode_array;
?>