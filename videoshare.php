<?php
$x = htmlspecialchars($_GET["x"]);
$myfile = fopen("videoshare.txt", "w") or die("Unable to open file!");
$txt = $x;
fwrite($myfile, $txt);
fclose($myfile);
echo $txt;
?>