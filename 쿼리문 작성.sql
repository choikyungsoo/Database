--customer를 담당하는 employee라면, 몇 명의 customer를 담당하는지 알아본다. 많은 customer를 상대할수록 높은 인센티브를 부여하기 위함이다.
select employee_id, count(*) as number_of_customer
from employee
natural join customer
group by employee_id
order by employee_id;

--customer가 원한 budget과 실제 들어간 real pay를 비교하여 real pay가 budget을 넘은 사례에 대해서는 이를 보완하는 전략을 짜고자 한다. real pay가 budget을 넘지 않는 사례를 참고하여  앞으로의 전략을 효과적으로 짜기 위함이다. 
select customer.customer_id, budget, sum(package.price + wedding_hall.price + rental_company.price) as realPay
from  customer, wedding_hall, rental_company, package, rental_customer
where customer.hall_id = wedding_hall.hall_id
and customer.customer_id = rental_customer.customer_id
and rental_customer.rental_company_id = rental_company.rental_company_id
and customer.package_id = package.package_id
group by customer.customer_id, budget;

--commission이 10%보다 높은 rental_company를 관리한다. 계속 계약을 유지할만한 rental_company가 아니라고 판단되면 계약을 해지하기 위함이다.
select rental_company_id, rental_company_name, commission
from rental_company
where commission>0.1
order by commission;

--price가 평균보다 낮은 rental_company를 관리한다. budget이 적은 customer에게 추천하기 위함이다.
select rental_company.rental_company_id, rental_company_name, address, r_phone_num
from rental_company, rc_phone
where rental_company.rental_company_id = rc_phone.rental_company_id
and price < (select avg(price) from rental_company);

--20대 customer가 주로 선택하는 package를 관리하고 이 정보를 travel_agency에 판매한다. travel_agency는 이 정보를 통해 더 나은 여행 패키지 서비스를 기획할 수 있고, 자사는 정보 판매 수익을 얻음과 동시에 20대 customer에게 package를 추천하기 용이하다.
select age, package.package_id, city, price
from customer, package
where customer.package_id = package.package_id
and age >20 and age <30
order by package.package_id;

--각각의 wedding_hall을 이용한 customer들의 수를 파악하여 인기가 많은 wedding_hall을 알아보고자 한다.
select hall_name, price, acceptable_num, count(customer_id) as number_of_customer 
from wedding_hall, customer
where wedding_hall.hall_id = customer.hall_id
group by hall_name, price, acceptable_num;

--price가 평균보다 높지만 commission이 평균보다 낮은, 가성비가 좋은 wedding_company를 관리한다. 이 정보는 앞으로의 계약 유지에 도움이 될 수 있다.
select wedding_hall.wedding_company_id, wcompany_name, price, commission, address, hall_name, acceptable_num 
from wedding_hall, wedding_company
where wedding_hall.wedding_company_id = wedding_company.wedding_company_id
and price<(select avg(price) from wedding_hall)
and commission<(select avg(commission) from wedding_company);

--인기가 많은 신혼 여행지, 하와이에 가는 package를 보유한 travel_agency를 관리한다. travel_agency가 target으로 하는 customer의 연령대를 평균값으로 측정하고 price를 함께 고려하여 customer에게 추천한다.
select distinct travel_agency.travel_agency_id, travel_agency_name, city, price, avg(target) as average_Age
from travel_agency, package, ta_target
where travel_agency.travel_agency_id = package.travel_agency_id
and travel_agency.travel_agency_id = ta_target.travel_agency_id
and city = 'Hawaii'
group by travel_agency.travel_agency_id, travel_agency_name, city, price
order by travel_agency.travel_agency_id;

--20대가 방문한 4000000원 미만 package를 관리한다. budget이 상대적으로 적은 20대 customer에게 추천하기 용이하다.
select target, country, city, price from travel_agency 
natural join package, ta_target 
where target = 20 
and price < 4000000 
group by target, country, city, price;

--바쁜 성수기에 결혼할 customer들을 대비하여 미리 준비하고자 성수기에 결혼한 customer들의 목록을 관리한다. 
select distinct  wedding_hall.hall_id, hall_name, acceptable_num, price, date_of_wedding, customer_id, fname, lname
from wedding_hall, customer
where wedding_hall.hall_id = customer.hall_id
group by wedding_hall.hall_id, acceptable_num, hall_name, price, date_of_wedding, customer_id, fname, lname
having date_of_wedding between '2021-09-01' and '2021-11-30';
