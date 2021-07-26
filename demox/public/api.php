<?php
$s = $_POST['search'];
header('Content-Type: application/json');
echo '{"success":true,"message":"Hello '.$s.'","date":"'.date('Y-m-d i').'"}';
