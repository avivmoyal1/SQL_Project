<?php
    // include "config.php";
    $dbhost = "localhost";
    $dbuser = "root";
    $dbpass = "db123456";
    $dbname = "pet_store";

    // define("URL" , "http://se.shenkar.ac.il/students/2021-2022/web1/dev_201/");
    // session_start();
    // if(empty($_SESSION["user_id"]))
    // {
    //     header('Location:' . URL . 'login.php');
    // }
    
    $connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
     if(mysqli_connect_errno()) {
         die("DB connection failed: " . mysqli_connect_error() . " (" . mysqli_connect_errno() . ")"
         );
     }
?>

<!DOCTYPE html>
<html>

<head>
    <title>SQL</title>
    <meta charset="UTF-8">
    <!-- my-css -->
    <link rel="stylesheet" href="style.css">
    <!-- CSS only -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">



</head >

<body class="container">
        <header>
        </header>
        <main>
            <ol>
                <li>Display of all products and stock quantity</li>
                <li>Show all the orders in the last X weeks</li>
                <li>Show the employee who sold the most products</li>
                <li>Show the employee who sold the most</li>
                <li>Display active orders and the customer who ordered</li>
                <li>Display customers who have not placed any orders.</li>
                <li>Display repeat customers (more than one order).</li>
                <li>Showing income X months back</li>
            </ol>
            <form action="#" method="GET">
                <label></label><input type="number" name="option" min="1" max="8" step="1">
                <button type="submit" value="Submit" >Submit</button>
            </form>

            
                
              <?php

                    $op = 0;
                    $flag = 0;
                    if(isset($_GET['option'])){
                        $op = $_GET['option'];
                    }
                    switch ($op){
                        case 1:
                           
                            echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> product name </div><div class='col-sm-2'> amount</div></div></div></b>";
                            $query = "SELECT product_name, amount from product";
                            $result = mysqli_query($connection,$query); 
                            while($row = mysqli_fetch_array($result)){
                                echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'>" . $row['product_name'] ."</div> <div class='col-sm-2'>" . $row['amount'] . "</div></div></div>";
                            }
                            break;
                        case 2:
                            echo '<form action="#" method="GET">';
                            echo '<label>weeks? </label><input type="number" name="weeks">';
                            echo '<input type="number" name="option" value='.$op.' style="display:none">';
                            echo '<button type="submit" value="Submit" >Submit</button>';
                            echo '</form>';
                            
                            if(isset($_GET['weeks'])){
                                echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-1'> order_id </div> <div class='col-sm-1'> customer_id </div> <div class='col-sm-1'> member_id </div> <div class='col-sm-1'> delivery </div> <div class='col-sm-1'> product_id  </div> <div class='col-sm-1'> price </div> <div class='col-sm-1'> order_date </div></div></div></b>";
                                $query = "SELECT * FROM store_order WHERE order_date >= curdate() - INTERVAL ".$_GET['weeks'] ." WEEK";
                                $result = mysqli_query($connection,$query); 
                                while($row = mysqli_fetch_array($result)){
                                    echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-1'>" . $row['order_id'] ."</div> <div class='col-sm-1'>" . $row['customer_id'] . "</div> <div class='col-sm-1'>" . $row['member_id'] . "</div> <div class='col-sm-1'>" . $row['delivery'] . "</div> <div class='col-sm-1'> " . $row['product_id'] . " </div> <div class='col-sm-1'>" . $row['price'] . "</div> <div class='col-sm-1'> " . $row['order_date'] . "</div></div></div>";
                                }
                            }
                            break;
                        case 3:
                            $query = "SELECT crew.member_id ,p_name, count(*) as amount FROM person 
                            INNER JOIN  crew 
                            ON
                                crew.person_id = person.person_id 
                            INNER JOIN store_order
                            ON
                                store_order.member_id = crew.member_id
                            group by p_name 
                            ORDER BY amount DESC LIMIT 1";
                            $result = mysqli_query($connection,$query); 

                            echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> member_id </div> <div class='col-sm-2'> name </div> <div class='col-sm-2'> amount </div> </div></div></b>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> " . $row['member_id'] ."</div> <div class='col-sm-2'>" . $row['p_name'] . "</div> <div class='col-sm-2'>" . $row['amount'] . "</div></div> </div>";
                            }
                            break;
                        case 4:
                            $query = "SELECT c.member_id ,p.p_name, sum(s.price) as total FROM person p
                            INNER JOIN  crew c
                            ON
                                c.person_id = p.person_id 
                            INNER JOIN store_order s
                            ON
                                s.member_id = c.member_id
                            group by p_name 
                            ORDER BY total DESC LIMIT 1";
                            $result = mysqli_query($connection,$query); 

                            echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> member id </div> <div class='col-sm-2'> name </div> <div class='col-sm-2'> total </div> </div></div></b>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'>" . $row['member_id'] ."</div> <div class='col-sm-2'>" . $row['p_name'] . "</div> <div class='col-sm-2'>" . $row['total'] . "</div></div> </div>";
                            }
                            break;
                        case 5:
                            $query = "SELECT  c.customer_id, p.p_name, s.order_id, s.product_id,s.price FROM person p	
                            INNER JOIN customer c 
                            ON
                                p.person_id = c.person_id
                            INNER JOIN store_order s 
                            ON
                                s.customer_id = c.customer_id
                            where s.delivery IS NULL";
                            $result = mysqli_query($connection,$query); 
                            echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> customer id </div> <div class='col-sm-2'> name </div> <div class='col-sm-2'> order id </div> <div class='col-sm-2'> product id </div> <div class='col-sm-2'> price </div></div></div></b>";
                            while($row = mysqli_fetch_array($result)){
                                echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'>" . $row['customer_id'] ."</div> <div class='col-sm-2'>" . $row['p_name'] . "</div> <div class='col-sm-2'>" . $row['order_id'] . "</div> <div class='col-sm-2'>" .$row['product_id']. "</div> <div class='col-sm-2'>" .$row['price']." </div></div</div>";
                                $flag++;
                            }
                            if($flag == 0){
                                echo "balalbablabl";
                                $flag =0;
                            }
                            
                            break;
                        case 6:
                            $query = "SELECT  c.customer_id, p.p_name FROM person p	
                            INNER JOIN customer c 
                            ON
                                p.person_id = c.person_id
                            LEFT JOIN store_order s 
                            ON
                                s.customer_id = c.customer_id
                            WHERE s.customer_id IS NULL";
                            $result = mysqli_query($connection,$query); 

                            echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> customer id </div> <div class='col-sm-2'> name </div></div></div></b>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'>" . $row['customer_id'] ."</div> <div class='col-sm-2'>" . $row['p_name'] . " </div></div></div>";
                            }
                            break;
                        case 7:
                            $query = "SELECT c.customer_id, p.p_name, count(*) AS delivery_amount FROM person p 
                            INNER JOIN customer c
                            ON 	
                                p.person_id = c.person_id
                            INNER JOIN store_order s
                            ON
                                c.customer_id = s.customer_id
                            GROUP BY p.p_name
                            having delivery_amount > 1
                            ORDER BY delivery_amount DESC";
                            $result = mysqli_query($connection,$query); 

                            echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> customer id </div> <div class='col-sm-2'> name </div><div class='col-sm-2'> order amount </div></div></div></b>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'>" . $row['customer_id'] ."</div> <div class='col-sm-2'>" . $row['p_name'] ."</div> <div class='col-sm-2'>" . $row['delivery_amount'] . " </div></div></div>";
                            }
                            break;
                        case 8:
                            echo '<form action="#" method="GET">';
                            echo '<label>month? </label><input type="number" name="month">';
                            echo '<input type="number" name="option" value='.$op.' style="display:none">';
                            echo '<button type="submit" value="Submit" >Submit</button>';
                            echo '</form>';
                            
                            if(isset($_GET['month'])){
                                echo "<b><div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'> revenues </div></div></div></b>";
                                $query = "SELECT sum(price) as revenues FROM store_order 
                                WHERE order_date >= curdate() - INTERVAL " .$_GET['month']. " month"; 
                                
                                $result = mysqli_query($connection,$query); 
                                while($row = mysqli_fetch_array($result)){
                                    echo "<div class='container text-center'><div class='row row-cols-auto'><div class='col-sm-2'>" . $row['revenues'] ."</div></div></div>";
                                }
                            }
                            break;
                        default:
                            //
                        
                        }

                    // $query = "SELECT product_name, amount from product";
                    // $result = mysqli_query($connection,$query); 
                    // while($row = mysqli_fetch_array($result)){
                    //     echo $row['product_name'] ;
                    // }
                ?>
          
     
        </main>
</body>
</html>

<?php
    // mysqli_close($connection);
?>

