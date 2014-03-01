<?php session_start();
$q=$_GET["q"];
$c = $_GET["c"];
$account_array = $_SESSION["account_checked"];
$account_array[$q] = $c;
$_SESSION["account_checked"] = $account_array;
?>