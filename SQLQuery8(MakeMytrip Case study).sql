--Make My trip Assignment:
--Segment wise distribution of total_user_Count and users who booked flight in Apr2022



CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');


Select * from booking_table;
Select * from user_table;

with apr_book as 
(
Select u.Segment , count(distinct b.user_id) as Users_who_Booked_flight_in_Apr2022 from booking_table b inner join user_Table u on b.user_id=u.User_id
where MONTH(booking_date)=4 and Line_of_business='Flight'
group by u.segment
)
, total_flight as
(
Select u.Segment, count(distinct u.user_id) as Total_user_count from user_Table u left join booking_table b  on b.user_id=u.User_id
group by u.Segment
)

Select a.*,b.Total_user_count from apr_book a inner join total_flight b on a.segment=b.segment;


-- Better Way
Select u.Segment, count(distinct u.user_id) as Total_user_count ,
count(distinct case when b.Line_of_business='Flight' and b.Booking_date between  '2022-04-01' and '2022-04-30' then b.User_id end) as Users_who_Booked_flight_in_Apr2022
from user_Table u left join booking_table b  on b.user_id=u.User_id
group by u.Segment

---------------------------------------------------
--Q2 : Identify users whose first booking was a hotel booking

Select * from 
(
Select *, rank()over(partition by user_id order by booking_date) as rnk from booking_table
) a 
where rnk=1 and Line_of_business='Hotel'

----------------------------------------------------------
--Q3: Write a query to calculate the days between first and last booking of each user.

Select user_id , min(Booking_date) as First_date , max(booking_Date) as Last_date , 
DATEDIFF(day,min(Booking_date),max(booking_Date)) as Days_bw_1st_last_booking 
from booking_table
group by user_id 

--Q4:Write a query to count the no. of flight and hotel bookings in each of the user segments for the year 2022

Select Segment , count(distinct case when Line_of_Business='Flight' then booking_id else null end ) as Flight_bookings,
count(distinct case when Line_of_Business='Hotel' then booking_id else null end ) as Flight_bookings
from booking_table b inner join user_table u on b.user_id=u.User_id
where year(booking_date)=2022
group by Segment
