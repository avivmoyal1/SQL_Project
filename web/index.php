<?php
    // include "config.php";
    $dbhost = "localhost";
    $dbuser = "root";
    $dbpass = "db123456";
    $dbname = "pet_store";

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


</head>

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

            <?php
                
            
            ?>
            <?php
                $to_print = 1;
                if(isset($_GET['option'])){
                    if(($_GET['option'] == 2 && !isset($_GET['weeks'])) || ( $_GET['option'] == 8 && !isset($_GET['month']))) 
                    {
                        $to_print = 0;
                    }
                }
                
                if($to_print == 1){
                    echo '<form action="#" method="GET">';
                    echo '<label><b>Insert a query number</b></label><input type="number" name="option" min="1" max="8" step="1" class="form-control">';
                    echo '<button type="submit" value="Submit" class="btn btn-primary">Submit</button>';
                    echo '</form>';
                }
            ?>
              <?php

                    $op = 0;
                    $flag = 0;
                    if(isset($_GET['option'])){
                        $op = $_GET['option'];
                    }


                    switch ($op){
                        case 1:
                            $count =1;
                            $query = "SELECT product_name, amount from product";
                            $result = mysqli_query($connection,$query); 
                            if(mysqli_num_rows($result) != 0){
                                echo "<table class='table table-hover '>";
                                echo "<thead><tr><th scope='col'>#</th><th scope='col'> product name </th><th scope='col'> amount</th></tr></thead><tbody>";
                            }
                            while($row = mysqli_fetch_array($result)){
                                echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['product_name'] ."</td> <td>" . $row['amount'] . "</td></tr>";
                                $count++;
                            }
                            if(mysqli_num_rows($result) != 0){
                                echo "</tbody></table>";
                            }
                            else{
                                echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                echo '<div class="card-header"><b>No result</b></div>';
                                echo '<div class="card-body">';
                                echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                echo '</div>';
                                echo '</div>';
                            }
                            
                            break;
                        case 2:
                            if(!isset($_GET['weeks'])){
                                echo '<form action="#" method="GET">';
                                echo '<label>Insert number of weeks </label><input class="form-control type="number" name="weeks">';
                                echo '<input type="number" name="option" value='.$op.' style="display:none">';
                                echo '<button type="submit" value="Submit" class="btn btn-primary">Submit</button>';
                                echo '</form>';
                            }
                            if(isset($_GET['weeks'])){

                                $count =1;
                                $query = "SELECT * FROM store_order WHERE order_date >= curdate() - INTERVAL ".$_GET['weeks'] ." WEEK";
                                $result = mysqli_query($connection,$query); 
                                if(mysqli_num_rows($result) != 0){
                                    echo "<table class='table table-hover'>";
                                    echo "<thead><tr><th scope='col'>#</th><th scope='col'> order id </th> <th scope='col'> customer id </th> <<th scope='col'> member id </th> <th scope='col'> delivery </th> <th scope='col'> product id  </th> <th scope='col'> price </th> <th scope='col'> order date </th></tr></thead><tbody>";
                                }
                                while($row = mysqli_fetch_array($result)){
                                    echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['order_id'] ."</th><td>" . $row['customer_id'] . "</th><td>" . $row['member_id'] . "</th><td>" . $row['delivery'] . "</th><td> " . $row['product_id'] . " </th><td>" . $row['price'] . "</th><td> " . $row['order_date'] . "</td></tr>";
                                    $count++;
                                }
                                if(mysqli_num_rows($result) != 0){
                                    echo "</tbody></table>";
                                }
                                else{
                                    echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                    echo '<div class="card-header"><b>No result</b></div>';
                                    echo '<div class="card-body">';
                                    echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                    echo '</div>';
                                    echo '</div>';
                            
                                }
                            }

                            break;
                        case 3:
                            $count =1;
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
                            if(mysqli_num_rows($result) != 0){
                                echo "<table class='table table-hover'>";
                                echo "<thead><tr><th scope='col'>#</th><th scope='col'> member_id </th> <th scope='col'> name </th> <th scope='col'> amount </th></tr></thead><tbody>";
                            }
                            while($row = mysqli_fetch_array($result)){
                                echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['member_id'] ."</th><td>" . $row['p_name'] . "</th><td>" . $row['amount'] . "</td></tr>";
                                $count++;
                            }
                            if(mysqli_num_rows($result) != 0){
                                echo "</tbody></table>";
                            }
                            else{
                                echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                echo '<div class="card-header"><b>No result</b></div>';
                                echo '<div class="card-body">';
                                echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                echo '</div>';
                                echo '</div>';
                        
                            }
                            break;
                        case 4:
                            $count =1;
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
                            if(mysqli_num_rows($result) != 0){

                                echo "<table class='table table-hover'>";
                                echo "<thead><tr><th scope='col'>#</th><th scope='col'> member id </th> <th scope='col'> name </th> <th scope='col'> total </th></tr></thead><tbody>";
                            }

                            while($row = mysqli_fetch_array($result)){
                                echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['member_id'] ."</th><td>" . $row['p_name'] . "</th><td>" . $row['total'] . "</td></tr>";
                                $count++;
                            
                            }
                            if(mysqli_num_rows($result) != 0){
                                echo "</tbody></table>";
                            }
                            else{
                                echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                echo '<div class="card-header"><b>No result</b></div>';
                                echo '<div class="card-body">';
                                echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                echo '</div>';
                                echo '</div>';
                        
                            }
                            break;
                        case 5:
                            $count =1;
                            $query = "SELECT  c.customer_id, p.p_name, s.order_id, s.product_id,s.price FROM person p	
                            INNER JOIN customer c 
                            ON
                                p.person_id = c.person_id
                            INNER JOIN store_order s 
                            ON
                                s.customer_id = c.customer_id
                            where s.delivery IS NULL";
                            $result = mysqli_query($connection,$query);
                            if(mysqli_num_rows($result) != 0){
                                
                                echo "<table class='table table-hover'>"; 
                                echo "<thead><tr><th scope='col'>#</th><th scope='col'> customer id </th> <th scope='col'> name </th> <th scope='col'> order id </th> <th scope='col'> product id </th> <th scope='col'> price </th></tr></thead><tbody>";
                            }
                            while($row = mysqli_fetch_array($result)){
                                echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['customer_id'] ."</th><td>" . $row['p_name'] . "</th><td>" . $row['order_id'] . "</th><td>" .$row['product_id']. "</th><td>" .$row['price']." </td></tr>";
                                $count++;
                                
                            }
                            if(mysqli_num_rows($result) != 0){
                            echo "</tbody></table>";
                            }
                            else{
                                echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                echo '<div class="card-header"><b>No result</b></div>';
                                echo '<div class="card-body">';
                                echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                echo '</div>';
                                echo '</div>';
                      
                            }
                            
                            break;
                        case 6:
                            $count =1;
                            $query = "SELECT  c.customer_id, p.p_name FROM person p	
                            INNER JOIN customer c 
                            ON
                                p.person_id = c.person_id
                            LEFT JOIN store_order s 
                            ON
                                s.customer_id = c.customer_id
                            WHERE s.customer_id IS NULL";
                            $result = mysqli_query($connection,$query);
                            if(mysqli_num_rows($result) != 0){
                                
                                echo "<table class='table table-hover'>"; 
                                echo "<thead><tr><th scope='col'>#</th><th scope='col'> customer id </th> <th scope='col'> name </th></tr></thead><tbody>";
                            } 
                            while($row = mysqli_fetch_array($result)){
                                echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['customer_id'] ."</th><td>" . $row['p_name'] . " </th><td>";
                                $count++;
                            }

                            if(mysqli_num_rows($result) != 0){
                                echo "</tbody></table>";
                                }
                            else{
                                echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                echo '<div class="card-header"><b>No result</b></div>';
                                echo '<div class="card-body">';
                                echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                echo '</div>';
                                echo '</div>';
                        
                            }
                            break;
                        case 7:
                            $count =1;

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
                            if(mysqli_num_rows($result) != 0){
                                
                                echo "<table class='table table-hover'>"; 
                                echo "<thead><tr><th scope='col'>#</th><th scope='col'> customer id </th> <th scope='col'> name </th> <th scope='col'>order amount</th></tr></thead><tbody>";
                            } 
                            while($row = mysqli_fetch_array($result)){
                                echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['customer_id'] ."</th><td>" . $row['p_name'] ."</th><td>" . $row['delivery_amount'] . "</th><td>";
                                $count++;
                            }
                            if(mysqli_num_rows($result) != 0){
                                echo "</tbody></table>";
                                }
                            else{
                                echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                echo '<div class="card-header"><b>No result</b></div>';
                                echo '<div class="card-body">';
                                echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                echo '</div>';
                                echo '</div>';
                        
                            }
                            
                            break;
                        case 8:
                            $count =1;

                            if(!isset($_GET['month'])){
                                echo '<form action="#" method="GET">';
                                echo '<label><b>Insert number of months<b> </label><input class="form-control type="number" type="number" name="month">';
                                echo '<input type="number" name="option" value='.$op.' style="display:none">';
                                echo '<button type="submit" value="Submit" class="btn btn-primary">Submit</button>';
                                echo '</form>';
                            }

                            if(isset($_GET['month'])){
                                $query = "SELECT sum(price) as revenues FROM store_order 
                                WHERE order_date >= curdate() - INTERVAL " .$_GET['month']. " month"; 
                                $result = mysqli_query($connection,$query); 

                                if(mysqli_num_rows($result) != 0){
                                
                                    echo "<table class='table table-hover'>"; 
                                    echo "<thead><tr><th scope='col'>#</th><th scope='col'> revenues </th></tr></thead><tbody>";
                                } 
                                while($row = mysqli_fetch_array($result)){
                                    echo "<tr><th scope='row'>" .$count . "</th><td>" . $row['revenues'] ."</th><td>";
                                    $count++;
                                }
                                if(mysqli_num_rows($result) != 0){
                                    echo "</tbody></table>";
                                    }
                                else{
                                    echo '<div class="card text-bg-light   mb-3" style="max-width: 18rem;">';
                                    echo '<div class="card-header"><b>No result</b></div>';
                                    echo '<div class="card-body">';
                                    echo '<p class="card-text">This query did not find any open orders in the database.</p>';
                                    echo '</div>';
                                    echo '</div>';
                            
                                }
                            }
                            break;
                        default:
                        
                        }

                ?>
          
     
        </main>
</body>
</html>

<?php
    mysqli_close($connection);
?>

