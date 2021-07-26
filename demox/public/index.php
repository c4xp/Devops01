<?php
include '../../cfg.php';
include_once(APP_DIR.DIRECTORY_SEPARATOR.'lib'.DIRECTORY_SEPARATOR.'db.class.php');

DB::connectPDO();

?>
<html>
    <head>
        <script src="/jquery.min.js"></script>
        <script>
            function ceva() {
                var cecontine = document.getElementById("search").value;
                $.ajax({
                    method: "POST",
                    url: "/api.php",
                    data: { search: cecontine }
                }).done(function(resp) {
                    alert(resp.message + ' at ' + resp.date);
                });
                return false;
            }
        </script>
    </head>
    <body>
        demox
        <?php echo filter_input(INPUT_POST, 'search', FILTER_SANITIZE_STRING) ?>
        <form method="post" action="/api.php" onsubmit="return ceva()">
        <input type="text" name="search" id="search">
        <input type="submit" name="submit" value="Ok">
        </form>
        <?php
        $rs = DB::query("SHOW DATABASES;");
        while ($r = $rs->fetch(PDO::FETCH_ASSOC)) {
            var_export($r);
        }
        ?>
    </body>
</html>