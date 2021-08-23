select account_id from bank.account;
-- quary 1
select client_id from client where district_id= 1 order by client_id asc limit 5;
-- quary 2
select client_id from client where district_id= 72 order by client_id desc limit 1;
-- quary 3
select amount from loan order by amount asc limit 3;
-- quary 4
select distinct status from loan order by status asc;
-- quary 5
select payments, loan_id from loan order by payments desc limit 1;

-- quary 6
select distinct(account_id) as id, amount from loan
order by id
ASC Limit 5;

-- quary 7
select duration from loan;
select account_id, amount from loan
where duration=60
order by amount 
ASC Limit 5;

-- quary 8
select distinct k_symbol from `order`;

-- quary 9
select order_id from `order` where account_id=34;

-- qyuary 10
select distinct account_id from `order` where order_id between 29540 and 29560;

-- quary 11

select amount from `order` where account_to = 30067122;

-- quary 12
select trans_id, date, type, amount from trans where account_id= 793 order by date desc limit 10;

-- quary 13 
select count(client_id), district_id from client where district_id < 10 group by district_id order by district_id; 

-- quary 14
select count(card_id), type from card group by type;

-- quary 15
select account_id, amount from loan group by amount order by amount desc limit 10;

-- quary 16
select count(loan_id), date from loan where date < 930907 group by date order by date desc;
