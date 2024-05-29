-- Sales Analysis

/* Q1. Retrieve the total number of orders placed.*/ /* answer: 21350*/
select count(order_id) as Total_orders from orders;

/* Q2. Calculate total revenue generated from pizza sale.*//* Answer: 817860.05*/
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

/* Q3. Identify the highest price pizza.*/ /* Answer: 35.95 */

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

/* Q4(a) Identify the best selling pizzas by size, type and category ordered.*/ 
/* Answer: The Big Meat Pizza	Classic	S	1914 */

SELECT 
    pizza_types.name,
    pizza_types.category,
    pizzas.size,
    SUM(order_details.quantity) AS total_qty
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name , pizza_types.category , pizzas.size
ORDER BY total_qty DESC
LIMIT 1;

/* Q4(b) Identify best seller pizza on the base of revenue.*/
/* Answer: The Thai Chicken Pizza	L	Chicken	29257.5 */

SELECT 
    pizza_types.name,
    pizzas.size,
    pizza_types.category,
    SUM(pizzas.price * order_details.quantity) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name , pizzas.size , pizza_types.category
ORDER BY total_revenue DESC
LIMIT 1;

/* Q5. List the 5 most ordered types along with their quantity.*/ /* Answer: # name, total_qty
'The Classic Deluxe Pizza', '2453'
'The Barbecue Chicken Pizza', '2432'
'The Hawaiian Pizza', '2422'
'The Pepperoni Pizza', '2418'
'The Thai Chicken Pizza', '2371'
*/
SELECT 
    pizza_types.name,
    ROUND(SUM(order_details.quantity), 2) AS total_qty
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_qty DESC
LIMIT 5;

/* Q6. Identify the total quantity of each pizza category ordered. */ Answer: # category, total_quantity
'Classic', '14888'
'Supreme', '11987'
'Veggie', '11649'
'Chicken', '11050'
*/

select pizza_types.category, round(sum(order_details.quantity),2) as total_quantity
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by total_quantity desc;

/* Q7(a). Determine the distribution of orders by hours of the day or peak sales hours.*/ 
/* # hours, order_count
'9', '1'
'10', '8'
'11', '1231'
'12', '2520'
'13', '2455'
'14', '1472'
'15', '1468'
'16', '1920'
'17', '2336'
'18', '2399'
'19', '2009'
'20', '1642'
'21', '1198'
'22', '663'
'23', '28'
*/

SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hours
ORDER BY hours, order_count DESC;

/* Q7(b). Determine day of the week with the highest number of orders.*/
/* Answer: # day_of_week, order_count
'Friday', '3538'
'Thursday', '3239'
'Saturday', '3158'
'Wednesday', '3024'
'Tuesday', '2973'
'Monday', '2794'
'Sunday', '2624'
*/
SELECT 
    dayname(order_date) AS day_of_week, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY day_of_week
ORDER BY order_count DESC;

/* Q8. Find categorywise distribution of pizzas. */ /* Answer: # category, count(name)
'Chicken', '6'
'Classic', '8'
'Supreme', '9'
'Veggie', '9'
*/

select category, count(name) 
from pizza_types
group by category;

/* Q9(a). calculate the average number of pizzas ordered per day.*/
/* Answer: # avg_daily_quantity
'138'
*/
SELECT 
    round(AVG(total_quantity),0) AS avg_daily_quantity
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS total_quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;

/* Q9(b). calculate the average number of pizzas ordered per week.*/ 
/* Answer: # avg_order
'935'
*/ 
SELECT 
    round(AVG(total_quantity),0) AS avg_order
FROM
    (SELECT 
        week(orders.order_date) as weekly_order,
            SUM(order_details.quantity) AS total_quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY weekly_order) AS order_quantity;


/* Q9(c). calculate the average number of pizzas ordered per month.*/  
/* # avg_order
'4131'
*/

SELECT 
    round(AVG(total_quantity),0) AS avg_order
FROM
    (SELECT 
        month(orders.order_date) as monthly_order,
            SUM(order_details.quantity) AS total_quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY monthly_order) AS order_quantity;    

/* Q10. Determine the top 3 most ordered pizza types based on revenue.*/
/* Answer: # name, revenue
'The Thai Chicken Pizza', '43434.25'
'The Barbecue Chicken Pizza', '42768'
'The California Chicken Pizza', '41409.5'
*/
select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id 
group by  pizza_types.name
order by revenue desc
limit 3;

/* Q11. Calculate the percentage contribution of each pizza type to total revenue.*/
/* Answer: # category, revenue
'Classic', '26.91'
'Supreme', '25.46'
'Chicken', '23.96'
'Veggie', '23.68'
*/

WITH total_sales AS (
    SELECT SUM(order_details.quantity * pizzas.price) AS total_sales
    FROM order_details
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
)
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (select total_sales from total_sales) * 100, 2) AS revenue
FROM
    pizza_types
JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    revenue DESC;
    
/* Q12. Analyze cumulative revenue generated over time.*/

select order_date, sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date, SUM(order_details.quantity * pizzas.price) as revenue
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on order_details.order_id = orders.order_id
group by orders.order_date) as sales;

/* Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/

select name, revenue, most_ordered_pizza from
(select category, name, revenue, 
rank() over(partition by category order by revenue desc) as most_ordered_pizza
from 
(select pizza_types.category, pizza_types.name,
SUM(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as A) as B
where most_ordered_pizza<=3 ;

/* Q14. Compare revenue across different pizza name, sizes, and categories.*/
SELECT 
    name, size, category, total_revenue
FROM
    (SELECT 
        pizza_types.name,
            pizzas.size,
            pizza_types.category,
            round(SUM(order_details.quantity * pizzas.price),2) AS total_revenue
    FROM
        pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id    
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
    
    GROUP BY pizza_types.name , pizzas.size , pizza_types.category) AS sales
order by total_revenue desc;
 
-- Customer Preferences:
-- Q15. Identify the most popular ingredients of each categories.
/* # category, ingredients, revenue, most_ordered_pizza
'Chicken', 'Chicken, Pineapple, Tomatoes, Red Peppers, Thai Sweet Chilli Sauce', '43434.25', '1'
'Classic', 'Pepperoni, Mushrooms, Red Onions, Red Peppers, Bacon', '38180.5', '1'
'Supreme', 'Capocollo, Tomatoes, Goat Cheese, Artichokes, Peperoncini verdi, Garlic', '34831.25', '1'
'Veggie', 'Ricotta Cheese, Gorgonzola Piccante Cheese, Mozzarella Cheese, Parmigiano Reggiano Cheese, Garlic', '32265.70000000065', '1'*/


select category, ingredients, revenue, most_ordered_pizza from
(select category, ingredients, revenue, 
rank() over(partition by category order by revenue desc) as most_ordered_pizza
from 
(select pizza_types.category, pizza_types.ingredients,
SUM(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.ingredients) as A) as B
where most_ordered_pizza = 1
order by revenue desc;

/* Q16 Analyze customer preferences for pizza size and type.*/
/* Answer: The Thai Chicken Pizza	L	29257.5	1
The Big Meat Pizza	S	22968	1
The Classic Deluxe Pizza	M	18896	1
The Greek Pizza	XL	14076	1
The Greek Pizza	XXL	1006.6000000000005	1*/

select name, size, revenue, most_ordered_pizza from
(select name, size, revenue, 
rank() over(partition by size order by revenue desc) as most_ordered_pizza
from 
(select pizza_types.name, pizzas.size,
SUM(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name,pizzas.size) as A) as B
where most_ordered_pizza = 1
order by revenue desc;

-- Q.17  Determine average order size and quantity of pizzas ordered
/* Answer: # avg_order_size, avg_pizza_per_order
'2.2773', '2.3220' */

SELECT 
    AVG(order_size) as avg_order_size, AVG(total_quantity) as avg_pizza_per_order
FROM
    (SELECT 
        order_id,
            COUNT(*) AS order_size,
            SUM(quantity) AS total_quantity
    FROM
        order_details
    GROUP BY order_id) AS order_detail;
    
/* Analyze order patterns to optimize kitchen operations and inventory management. */
/* Answer: 12	Thursday	Classic	345
12	Tuesday	Classic	344
12	Wednesday	Classic	338
13	Thursday	Classic	330
12	Friday	Classic	325
13	Friday	Classic	318
18	Friday	Classic	313
13	Tuesday	Classic	312
12	Monday	Classic	312
12	Thursday	Supreme	287
12	Monday	Veggie	286
13	Thursday	Supreme	284
13	Wednesday	Classic	276
12	Monday	Supreme	276
13	Thursday	Veggie	274
12	Tuesday	Supreme	274
12	Friday	Supreme	271
18	Saturday	Classic	264
12	Thursday	Veggie	263
17	Thursday	Classic	262
12	Tuesday	Veggie	262
13	Friday	Veggie	256
12	Thursday	Chicken	254
12	Friday	Chicken	253
12	Friday	Veggie	252
12	Monday	Chicken	252
12	Wednesday	Veggie	251
13	Monday	Classic	250
12	Wednesday	Supreme	249
18	Thursday	Classic	248
17	Friday	Classic	248
13	Tuesday	Supreme	247
18	Saturday	Supreme	244
13	Thursday	Chicken	243
13	Wednesday	Supreme	243
20	Saturday	Classic	241
13	Friday	Supreme	241
17	Sunday	Classic	239
13	Saturday	Classic	238
19	Saturday	Classic	235
17	Monday	Classic	233
13	Tuesday	Veggie	230
19	Saturday	Supreme	229
13	Tuesday	Chicken	229
18	Friday	Veggie	226
13	Wednesday	Veggie	226
13	Friday	Chicken	225
12	Tuesday	Chicken	225
18	Sunday	Classic	220
12	Wednesday	Chicken	220
19	Friday	Classic	219
17	Wednesday	Classic	214
16	Thursday	Classic	212
17	Thursday	Supreme	211
18	Friday	Supreme	210
18	Wednesday	Classic	210
17	Tuesday	Classic	208
16	Sunday	Classic	207
13	Sunday	Classic	207
16	Saturday	Classic	205
17	Saturday	Classic	204
13	Monday	Chicken	200
17	Thursday	Veggie	198
20	Friday	Classic	197
18	Saturday	Veggie	196
18	Monday	Classic	196
18	Wednesday	Chicken	194
13	Wednesday	Chicken	193
12	Saturday	Classic	193
18	Thursday	Veggie	192
18	Thursday	Chicken	191
21	Friday	Classic	190
14	Thursday	Classic	190
13	Saturday	Veggie	190
19	Saturday	Chicken	189
17	Wednesday	Supreme	189
17	Wednesday	Chicken	189
19	Saturday	Veggie	188
18	Friday	Chicken	187
19	Friday	Veggie	186
18	Wednesday	Supreme	186
17	Thursday	Chicken	185
13	Saturday	Supreme	185
12	Sunday	Classic	182
18	Tuesday	Classic	181
17	Saturday	Chicken	181
16	Wednesday	Classic	181
13	Saturday	Chicken	181
21	Saturday	Classic	180
20	Saturday	Veggie	180
17	Wednesday	Veggie	180
17	Friday	Supreme	179
19	Friday	Chicken	178
17	Saturday	Veggie	178
19	Tuesday	Classic	177
18	Saturday	Chicken	177
13	Monday	Veggie	177
20	Friday	Supreme	176
19	Sunday	Classic	176
18	Thursday	Supreme	176
18	Sunday	Supreme	176
13	Monday	Supreme	176
13	Sunday	Supreme	173
18	Sunday	Chicken	172
20	Friday	Veggie	170
16	Tuesday	Classic	170
18	Tuesday	Supreme	169
17	Friday	Chicken	169
17	Tuesday	Veggie	168
16	Friday	Classic	168
14	Friday	Classic	167
12	Saturday	Veggie	167
18	Monday	Veggie	166
18	Wednesday	Veggie	166
17	Saturday	Supreme	166
17	Sunday	Supreme	166
14	Saturday	Classic	166
19	Friday	Supreme	165
17	Monday	Chicken	165
18	Sunday	Veggie	164
16	Tuesday	Supreme	164
20	Friday	Chicken	163
17	Friday	Veggie	163
17	Monday	Supreme	162
19	Thursday	Classic	161
18	Monday	Chicken	161
17	Tuesday	Supreme	161
16	Thursday	Supreme	161
13	Sunday	Chicken	161
11	Wednesday	Classic	161
19	Monday	Classic	160
20	Saturday	Chicken	159
18	Tuesday	Veggie	159
20	Saturday	Supreme	158
16	Saturday	Veggie	158
17	Sunday	Veggie	157
16	Tuesday	Chicken	157
21	Friday	Supreme	156
12	Sunday	Veggie	156
19	Tuesday	Supreme	155
14	Wednesday	Classic	155
12	Saturday	Chicken	153
11	Monday	Classic	153
19	Thursday	Supreme	152
17	Sunday	Chicken	152
17	Monday	Veggie	152
11	Thursday	Classic	151
16	Monday	Classic	149
14	Sunday	Classic	149
21	Saturday	Chicken	148
15	Saturday	Classic	148
13	Sunday	Veggie	148
15	Thursday	Classic	147
15	Wednesday	Classic	147
14	Thursday	Supreme	147
14	Tuesday	Classic	147
16	Saturday	Supreme	146
16	Sunday	Supreme	146
19	Sunday	Veggie	145
19	Sunday	Supreme	144
16	Monday	Supreme	144
15	Saturday	Supreme	144
19	Thursday	Veggie	143
18	Monday	Supreme	143
16	Thursday	Veggie	143
21	Friday	Veggie	142
19	Wednesday	Classic	142
20	Tuesday	Classic	141
16	Tuesday	Veggie	139
16	Friday	Veggie	139
16	Saturday	Chicken	137
16	Sunday	Veggie	137
14	Wednesday	Veggie	137
19	Tuesday	Veggie	136
16	Friday	Chicken	136
16	Wednesday	Veggie	136
11	Friday	Classic	136
16	Friday	Supreme	135
16	Monday	Veggie	135
12	Sunday	Supreme	135
19	Wednesday	Supreme	134
16	Thursday	Chicken	134
16	Sunday	Chicken	133
11	Wednesday	Supreme	133
21	Saturday	Veggie	132
19	Monday	Veggie	132
19	Tuesday	Chicken	132
17	Tuesday	Chicken	132
21	Saturday	Supreme	131
19	Thursday	Chicken	131
15	Sunday	Classic	131
14	Friday	Veggie	131
12	Sunday	Chicken	131
18	Tuesday	Chicken	130
15	Sunday	Supreme	129
16	Wednesday	Chicken	128
20	Sunday	Classic	127
19	Wednesday	Veggie	127
16	Wednesday	Supreme	126
14	Sunday	Supreme	126
21	Friday	Chicken	125
20	Monday	Classic	125
14	Saturday	Supreme	125
20	Thursday	Veggie	124
19	Monday	Chicken	124
14	Sunday	Chicken	124
14	Monday	Classic	124
15	Monday	Classic	122
19	Monday	Supreme	121
15	Thursday	Veggie	121
14	Saturday	Veggie	121
14	Sunday	Veggie	121
11	Thursday	Supreme	121
11	Tuesday	Classic	121
11	Wednesday	Chicken	121
15	Tuesday	Classic	120
14	Thursday	Veggie	120
12	Saturday	Supreme	120
14	Tuesday	Supreme	119
11	Monday	Chicken	119
11	Wednesday	Veggie	119
15	Friday	Veggie	118
15	Saturday	Veggie	118
14	Saturday	Chicken	118
14	Monday	Supreme	118
14	Thursday	Chicken	117
14	Tuesday	Veggie	117
20	Tuesday	Supreme	115
15	Saturday	Chicken	115
15	Sunday	Chicken	115
14	Monday	Chicken	115
20	Tuesday	Chicken	114
15	Friday	Classic	114
15	Wednesday	Veggie	114
14	Friday	Chicken	114
20	Wednesday	Classic	113
19	Wednesday	Chicken	113
16	Monday	Chicken	113
15	Wednesday	Supreme	113
14	Friday	Supreme	113
14	Wednesday	Supreme	113
22	Saturday	Classic	112
20	Thursday	Chicken	112
20	Thursday	Classic	112
19	Sunday	Chicken	112
15	Sunday	Veggie	111
14	Wednesday	Chicken	111
15	Tuesday	Supreme	110
15	Monday	Chicken	108
11	Tuesday	Supreme	108
22	Friday	Classic	106
20	Tuesday	Veggie	106
15	Friday	Supreme	106
15	Tuesday	Veggie	105
14	Tuesday	Chicken	105
20	Thursday	Supreme	103
15	Friday	Chicken	103
15	Monday	Supreme	103
14	Monday	Veggie	103
20	Wednesday	Veggie	102
15	Thursday	Supreme	102
11	Thursday	Veggie	102
11	Tuesday	Veggie	101
11	Monday	Supreme	101
22	Friday	Supreme	100
20	Sunday	Supreme	100
11	Monday	Veggie	99
15	Thursday	Chicken	98
20	Sunday	Veggie	97
11	Tuesday	Chicken	96
20	Wednesday	Supreme	95
11	Thursday	Chicken	94
15	Wednesday	Chicken	91
11	Friday	Supreme	91
22	Friday	Chicken	89
21	Tuesday	Classic	88
20	Wednesday	Chicken	88
20	Monday	Veggie	87
22	Friday	Veggie	86
15	Tuesday	Chicken	85
22	Saturday	Veggie	84
21	Monday	Classic	84
21	Monday	Chicken	84
21	Sunday	Supreme	83
20	Sunday	Chicken	81
11	Friday	Chicken	81
11	Friday	Veggie	80
11	Sunday	Classic	80
21	Sunday	Classic	79
20	Monday	Supreme	79
15	Monday	Veggie	78
21	Wednesday	Supreme	77
21	Wednesday	Classic	77
22	Saturday	Supreme	76
22	Saturday	Chicken	71
21	Sunday	Chicken	71
21	Sunday	Veggie	71
20	Monday	Chicken	69
21	Wednesday	Veggie	68
21	Tuesday	Veggie	67
21	Thursday	Classic	62
11	Saturday	Supreme	61
11	Sunday	Supreme	61
21	Tuesday	Supreme	60
21	Monday	Supreme	58
11	Saturday	Classic	58
21	Tuesday	Chicken	57
21	Thursday	Supreme	53
21	Thursday	Veggie	53
21	Monday	Veggie	52
11	Sunday	Veggie	50
21	Wednesday	Chicken	49
21	Thursday	Chicken	48
22	Tuesday	Classic	47
11	Saturday	Veggie	46
22	Tuesday	Supreme	44
22	Wednesday	Chicken	43
11	Saturday	Chicken	43
22	Sunday	Chicken	41
11	Sunday	Chicken	41
22	Sunday	Supreme	39
22	Wednesday	Classic	37
22	Thursday	Classic	34
22	Wednesday	Veggie	34
22	Monday	Supreme	33
22	Sunday	Classic	33
22	Wednesday	Supreme	32
22	Sunday	Veggie	30
22	Monday	Veggie	30
22	Thursday	Supreme	29
22	Tuesday	Veggie	29
22	Tuesday	Chicken	28
22	Thursday	Chicken	26
22	Monday	Chicken	26
22	Thursday	Veggie	24
22	Monday	Classic	23
23	Saturday	Veggie	11
23	Friday	Supreme	10
23	Saturday	Supreme	7
23	Saturday	Chicken	7
23	Saturday	Classic	6
23	Friday	Chicken	6
23	Friday	Veggie	5
23	Friday	Classic	5
23	Sunday	Supreme	3
10	Monday	Chicken	3
23	Thursday	Chicken	2
23	Monday	Classic	2
10	Wednesday	Veggie	2
10	Wednesday	Classic	2
10	Saturday	Classic	2
10	Thursday	Chicken	2
10	Thursday	Classic	2
9	Tuesday	Classic	2
23	Thursday	Veggie	1
23	Sunday	Veggie	1
23	Monday	Veggie	1
23	Monday	Supreme	1
10	Saturday	Supreme	1
10	Wednesday	Chicken	1
10	Thursday	Supreme	1
10	Sunday	Chicken	1
10	Sunday	Supreme	1
9	Tuesday	Supreme	1
9	Tuesday	Veggie	1*/
SELECT 
    hours,
    day_of_week,
    category,
    SUM(total_quantity) AS total_quantity
FROM (
    SELECT 
        HOUR(order_time) AS hours,
        DAYNAME(order_date) AS day_of_week,
        SUM(order_details.quantity) AS total_quantity,
        pizza_types.category as category
    FROM
        orders
    JOIN order_details ON order_details.order_id = orders.order_id
    join pizzas ON pizzas.pizza_id = order_details.pizza_id  
    join pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    GROUP BY
        HOUR(order_time),
        DAYNAME(order_date),
        pizza_types.category
) AS order_detail
GROUP BY
    hours, day_of_week, category
ORDER BY
    total_quantity DESC, hours DESC;
    
