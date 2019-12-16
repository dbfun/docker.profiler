<?php

function getYesNo($msg)
{
  while(true) {
    $str = readline($msg . ' ');
    $str = strtolower(trim($str));
    if(in_array($str, ["y", "yes"])) return true;
    if(in_array($str, ["n", "no"])) return false;
  }

}

$fileName = "/var/www/site/bitrix/.settings.php";
$data = include $fileName;
$db =& $data["connections"]["value"]["default"];
if(!isset($db)) throw new \Exception("Wrong file /var/www/site/bitrix/.settings.php");
$db["host"] = "mysql";
$db["database"] = getenv("MYSQL_DATABASE");
$db["login"] = getenv("MYSQL_USER");
$db["password"] = getenv("MYSQL_PASSWORD");

$data = '<?php' . PHP_EOL . 'return ' . var_export($data, true) . ';';

echo "File: $fileName\n";
echo $data;
echo PHP_EOL;

$result = getYesNo("Is this correct (yes/no)?");
if($result) {
  file_put_contents($fileName, $data);
}


$fileName = "/var/www/site/bitrix/php_interface/dbconn.php";
$data = file_get_contents($fileName);
$data = preg_replace('~^\$DBHost\s*=\s*".*";$~m', '$DBHost = "mysql";', $data);
$data = preg_replace('~^\$DBLogin\s*=\s*".*";$~m', '$DBLogin = "'.getenv("MYSQL_USER").'";', $data);
$data = preg_replace('~^\$DBPassword\s*=\s*".*";$~m', '$DBPassword = "'.getenv("MYSQL_PASSWORD").'";', $data);
$data = preg_replace('~^\$DBName\s*=\s*".*";$~m', '$DBName = "'.getenv("MYSQL_DATABASE").'";', $data);
$data = preg_replace('~^define\("BX_TEMPORARY_FILES_DIRECTORY",\s*".*"\);$~m', 'define("BX_TEMPORARY_FILES_DIRECTORY", "/tmp");', $data);
$data = preg_replace('~^\$_SERVER\["SERVER_PORT"\]\s*=\s*".*";$~m', '$_SERVER["SERVER_PORT"] = "80";', $data);

echo PHP_EOL;
echo "File: $fileName\n";
echo $data;
echo PHP_EOL;

$result = getYesNo("Is this correct (yes/no)?");
if($result) {
  file_put_contents($fileName, $data);
}
