<?php
include '../../cfg.php';
include_once(APP_DIR.DIRECTORY_SEPARATOR.'lib'.DIRECTORY_SEPARATOR.'db.class.php');

DB::connectPDO();

?>
<html>
    <body>
demox
<?php echo filter_input(INPUT_POST, 'searchify', FILTER_SANITIZE_STRING) ?>
<form method="post" action="/">
<input type="text" name="searchify">
<input type="submit" name="submit">
</form>
<?php
$rs = DB::query("SHOW DATABASES;");
while ($r = $rs->fetch(PDO::FETCH_ASSOC)) {
    var_export($r);
}
?>
    </body>
</html>