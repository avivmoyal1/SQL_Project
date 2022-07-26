<?php
    include "config.php";
    define("URL" , "http://se.shenkar.ac.il/students/2021-2022/web1/dev_201/");
    session_start();
    if(empty($_SESSION["user_id"]))
    {
        header('Location:' . URL . 'login.php');
    }
    
    $connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
    if(mysqli_connect_errno()) {
        die("DB connection failed: " . mysqli_connect_error() . " (" . mysqli_connect_errno() . ")"
        );
    }
?>

<!DOCTYPE html>
<html>

<head>
    <title>SafeGame</title>
    <meta charset="UTF-8">
    <!-- my-css -->
    <link rel="stylesheet" href="css/style.css">



</head>

<body >
        <header>
        </header>


</body>
</html>

<?php
    mysqli_close($connection);
?>

