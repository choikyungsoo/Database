--customer�� ����ϴ� employee���, �� ���� customer�� ����ϴ��� �˾ƺ���. ���� customer�� ����Ҽ��� ���� �μ�Ƽ�긦 �ο��ϱ� �����̴�.
select employee_id, count(*) as number_of_customer
from employee
natural join customer
group by employee_id
order by employee_id;

--customer�� ���� budget�� ���� �� real pay�� ���Ͽ� real pay�� budget�� ���� ��ʿ� ���ؼ��� �̸� �����ϴ� ������ ¥���� �Ѵ�. real pay�� budget�� ���� �ʴ� ��ʸ� �����Ͽ�  �������� ������ ȿ�������� ¥�� �����̴�. 
select customer.customer_id, budget, sum(package.price + wedding_hall.price + rental_company.price) as realPay
from  customer, wedding_hall, rental_company, package, rental_customer
where customer.hall_id = wedding_hall.hall_id
and customer.customer_id = rental_customer.customer_id
and rental_customer.rental_company_id = rental_company.rental_company_id
and customer.package_id = package.package_id
group by customer.customer_id, budget;

--commission�� 10%���� ���� rental_company�� �����Ѵ�. ��� ����� �����Ҹ��� rental_company�� �ƴ϶�� �ǴܵǸ� ����� �����ϱ� �����̴�.
select rental_company_id, rental_company_name, commission
from rental_company
where commission>0.1
order by commission;

--price�� ��պ��� ���� rental_company�� �����Ѵ�. budget�� ���� customer���� ��õ�ϱ� �����̴�.
select rental_company.rental_company_id, rental_company_name, address, r_phone_num
from rental_company, rc_phone
where rental_company.rental_company_id = rc_phone.rental_company_id
and price < (select avg(price) from rental_company);

--20�� customer�� �ַ� �����ϴ� package�� �����ϰ� �� ������ travel_agency�� �Ǹ��Ѵ�. travel_agency�� �� ������ ���� �� ���� ���� ��Ű�� ���񽺸� ��ȹ�� �� �ְ�, �ڻ�� ���� �Ǹ� ������ ������ ���ÿ� 20�� customer���� package�� ��õ�ϱ� �����ϴ�.
select age, package.package_id, city, price
from customer, package
where customer.package_id = package.package_id
and age >20 and age <30
order by package.package_id;

--������ wedding_hall�� �̿��� customer���� ���� �ľ��Ͽ� �αⰡ ���� wedding_hall�� �˾ƺ����� �Ѵ�.
select hall_name, price, acceptable_num, count(customer_id) as number_of_customer 
from wedding_hall, customer
where wedding_hall.hall_id = customer.hall_id
group by hall_name, price, acceptable_num;

--price�� ��պ��� ������ commission�� ��պ��� ����, ������ ���� wedding_company�� �����Ѵ�. �� ������ �������� ��� ������ ������ �� �� �ִ�.
select wedding_hall.wedding_company_id, wcompany_name, price, commission, address, hall_name, acceptable_num 
from wedding_hall, wedding_company
where wedding_hall.wedding_company_id = wedding_company.wedding_company_id
and price<(select avg(price) from wedding_hall)
and commission<(select avg(commission) from wedding_company);

--�αⰡ ���� ��ȥ ������, �Ͽ��̿� ���� package�� ������ travel_agency�� �����Ѵ�. travel_agency�� target���� �ϴ� customer�� ���ɴ븦 ��հ����� �����ϰ� price�� �Բ� ����Ͽ� customer���� ��õ�Ѵ�.
select distinct travel_agency.travel_agency_id, travel_agency_name, city, price, avg(target) as average_Age
from travel_agency, package, ta_target
where travel_agency.travel_agency_id = package.travel_agency_id
and travel_agency.travel_agency_id = ta_target.travel_agency_id
and city = 'Hawaii'
group by travel_agency.travel_agency_id, travel_agency_name, city, price
order by travel_agency.travel_agency_id;

--20�밡 �湮�� 4000000�� �̸� package�� �����Ѵ�. budget�� ��������� ���� 20�� customer���� ��õ�ϱ� �����ϴ�.
select target, country, city, price from travel_agency 
natural join package, ta_target 
where target = 20 
and price < 4000000 
group by target, country, city, price;

--�ٻ� �����⿡ ��ȥ�� customer���� ����Ͽ� �̸� �غ��ϰ��� �����⿡ ��ȥ�� customer���� ����� �����Ѵ�. 
select distinct  wedding_hall.hall_id, hall_name, acceptable_num, price, date_of_wedding, customer_id, fname, lname
from wedding_hall, customer
where wedding_hall.hall_id = customer.hall_id
group by wedding_hall.hall_id, acceptable_num, hall_name, price, date_of_wedding, customer_id, fname, lname
having date_of_wedding between '2021-09-01' and '2021-11-30';
