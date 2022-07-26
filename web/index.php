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
    <title>SafeGame</title>
    <meta charset="UTF-8">
    <!-- my-css -->
    <link rel="stylesheet" href="style.css">



</head>

<body>
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

            <div>
                
              <?php
                    $op = 0;
                    if(isset($_GET['option'])){
                        $op = $_GET['option'];
                    }
                    switch ($op){
                        case 1:
                            echo "<section>product name<span> </span><span>amount</span></section>";
                            $query = "SELECT product_name, amount from product";
                            $result = mysqli_query($connection,$query); 
                            while($row = mysqli_fetch_array($result)){
                                echo "<section><span>" . $row['product_name'] ."</span> <span>" . $row['amount'] . "</span></section>";
                     }
                            break;
                        case 2:
                            echo '<form action="#" method="GET">';
                            echo '<label>weeks? </label><input type="number" name="weeks">';
                            echo '<input type="number" name="option" value='.$op.' style="display:none">';
                            echo '<button type="submit" value="Submit" >Submit</button>';
                            echo '</form>';
                            
                            if(isset($_GET['weeks'])){
                                echo "<section><span> order_id </span> <span> customer_id </span> <span> member_id </span> <span> delivery </span> <span> product_id  </span> <span> price </span> <span> order_date </span></section>";
                                $query = "SELECT * FROM store_order WHERE order_date >= curdate() - INTERVAL ".$_GET['weeks'] ." WEEK";
                                $result = mysqli_query($connection,$query); 
                                while($row = mysqli_fetch_array($result)){
                                    echo "<section><span>" . $row['order_id'] ."</span> <span>" . $row['customer_id'] . "</span> <span>" . $row['member_id'] . "</span> <span>" . $row['delivery'] . "</span> <span> " . $row['product_id'] . " </span> <span>" . $row['price'] . "</span> <span> " . $row['order_date'] . "</span></section>";
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

                            echo "<section><span> member_id </span> <span> name </span> <span> amount </span> </section>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<section><span>" . $row['member_id'] ."</span> <span>" . $row['p_name'] . "</span> <span>" . $row['amount'] . "</span> </section>";
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

                            echo "<section><span> member id </span> <span> name </span> <span> total </span> </section>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<section><span>" . $row['member_id'] ."</span> <span>" . $row['p_name'] . "</span> <span>" . $row['total'] . "</span> </section>";
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

                            echo "<section><span> customer id </span> <span> name </span> <span> order id </span> <span> product id </span> <span> price </span></section>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<section><span>" . $row['customer_id'] ."</span> <span>" . $row['p_name'] . "</span> <span>" . $row['order_id'] . "</span> <span>" .$row['product_id']. "</span> <span>" .$row['price']." </span></section>";
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

                            echo "<section><span> customer id </span> <span> name </span> </section>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<section><span>" . $row['customer_id'] ."</span> <span>" . $row['p_name'] . " </span></section>";
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

                            echo "<section><span> customer id </span> <span> name </span><span> order amount </span> </section>";

                            while($row = mysqli_fetch_array($result)){
                                echo "<section><span>" . $row['customer_id'] ."</span> <span>" . $row['p_name'] ."</span> <span>" . $row['delivery_amount'] . " </span></section>";
                            }
                            break;
                        case 8:
                            echo '<form action="#" method="GET">';
                            echo '<label>month? </label><input type="number" name="month">';
                            echo '<input type="number" name="option" value='.$op.' style="display:none">';
                            echo '<button type="submit" value="Submit" >Submit</button>';
                            echo '</form>';
                            
                            if(isset($_GET['month'])){
                                echo "<section><span> revenues </span></section>";
                                $query = "SELECT sum(price) as revenues FROM store_order 
                                WHERE order_date >= curdate() - INTERVAL " .$_GET['month']. " month"; 
                                
                                $result = mysqli_query($connection,$query); 
                                while($row = mysqli_fetch_array($result)){
                                    echo "<section><span>" . $row['revenues'] ."</span></section>";
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
          
            </div>
        </main>
</body>
</html>

<?php
    // mysqli_close($connection);
?>

