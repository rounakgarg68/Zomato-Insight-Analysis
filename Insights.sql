use zomato;



/* 1 What is the total amount each customer spent on zomato ?

select s.userid,sum(p.price) as total_amount_spent from sales s join product p on s.product_id = p.product_id
group by s.userid; */ 

/* 2 How many days each customer visited zomato ?

select userid,count(created_date) no_of_times_visited from sales group by userid; */

/* 3 What was the first product purchaed by the each customer?

select userid,created_date,product_name from(
select s.userid as userid,s.created_date,s.product_id,p.product_name as product_name,dense_rank() over(partition by s.userid order by s.created_date) as rn
from sales s join product p on s.product_id = p.product_id)t
where t.rn =1; */

/* 4 What is the most purchased item on menu and how many times was it purchased by all customers?

select userid,count(product_id) as total from sales where product_id =
(select product_id from sales group by product_id order by count(product_id) desc limit 1)
group by userid */

/* 5 Which Item was the most popular for each customer ?
select userid,product_id from(
select userid,product_id,count(*),dense_rank() over(partition by userid order by count(*) desc) as rn from sales
group by userid,product_id)t
where t.rn = 1; */

/*6 Which item was first purchased by customer after they became gold member ?

select userid,product_id,created_date from(
select g.userid as userid,g.gold_signup_date as gold_signup_date,s.created_date as created_date,s.product_id as product_id,
dense_rank() over(partition by g.userid order by s.created_date) as rn
from
goldusers_signup g join sales s on g.userid = s.userid and s.created_date >= g.gold_signup_date
)t where t.rn = 1;*/

/*7 which items are just purchased just become the member
select userid,product_id,created_date from(
select g.userid as userid,g.gold_signup_date as gold_signup_date,s.created_date as created_date,s.product_id as product_id,
dense_rank() over(partition by g.userid order by s.created_date desc) as rn
from
goldusers_signup g join sales s on g.userid = s.userid and s.created_date < g.gold_signup_date
)t where t.rn = 1;*/

/* 8 what is the total order and amount spent by each customer before they became a member?

select g.userid,count(s.product_id),sum(p.price) from 
goldusers_signup g join sales s on g.userid = s.userid
join product p on s.product_id = p.product_id 
where s.created_date < g.gold_signup_date
group by g.userid; */


/* 9 - If buying each product generates a point for eg 5rs = 2 zomato point and each product has different purchasing points
for eg for p1 5rs = 1 point,for p2 2rs = 1 point and for p3 5rs = 1 point

calculate points collected by each customers and for which product most points have been given till now.

with CTE as(
select s.userid as userid ,s.product_id as product_id,sum(p.price) as total,
case when s.product_id = 1 then round(sum(p.price)/5) 
when s.product_id = 2 then round(sum(p.price)/2)
else round(sum(p.price)/5)
end as total_points
from sales s join product p on s.product_id = p.product_id
group by s.userid,s.product_id
)

select userid,sum(total_points)*2.5 from CTE group by userid; 

select product_id from CTE group by product_id order by sum(total_points) desc limit 1; */


/* 10 In the first one year after a customer joins the gold program(including their join date) 
irrespective of what the customer has purchased they earn 5 zomato points for every 10 rs 
calculate the total points earning in their first year

select g.userid,round(sum(p.price)/2)  from 
goldusers_signup g join sales s on g.userid = s.userid  join product p
on s.product_id = p.product_id
and s.created_date between g.gold_signup_date and DATE_ADD(g.gold_signup_date, INTERVAL 1 YEAR)
group by g.userid;*/


/* 11  Find all the transactions for each member whenever they are a zomato gold member and for every non gold member transaction 
mark as na 

select s.*,case
when  s.userid not in (select userid from goldusers_signup) or s.created_date < g.gold_signup_date   then 'NA'
else  rank() over(partition by s.userid order by s.created_date desc) 
end as result from sales s left join goldusers_signup g on
s.userid = g.userid; */

































   
  






