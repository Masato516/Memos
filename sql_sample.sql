DROP DATABASE IF EXISTS sample_db;
CREATE DATABASE sample_db;
USE sample_db;


DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
             id INT UNSIGNED AUTO_INCREMENT,
             name VARCHAR(100) NOT NULL,
             address VARCHAR(100),
             created_at DATETIME NOT NULL,
             updated_at DATETIME NOT NULL,
             PRIMARY KEY(id)
             );

CREATE TABLE items(
             id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             name VARCHAR(100) NOT NULL,
             price INT NOT NULL,
             created_at DATETIME NOT NULL,
             updated_at DATETIME NOT NULL
             );

CREATE TABLE items(
             id INT UNSIGNED NOT NULL AUTO_INCREMENT,
             name VARCHAR(100) NOT NULL,
             price INT NOT NULL,
             created_at DATETIME NOT NULL,
             updated_at DATETIME NOT NULL,
             PRIMARY KEY(id)
             );
             

CREATE TABLE orders(
             id INT UNSIGNED AUTO_INCREMENT,
             order_date DATE NOT NULL,
             customer_id INT UNSIGNED NOT NULL,
             created_at DATETIME NOT NULL,
             updated_at DATETIME NOT NULL,
             PRIMARY KEY(id),
             FOREIGN KEY(customer_id) REFERENCES customers(id)
             );
             
CREATE TABLE order_details(
            id INT UNSIGNED AUTO_INCREMENT,
            order_id INT UNSIGNED NOT NULL,
            item_id INT UNSIGNED NOT NULL,
            item_quantity INT UNSIGNED NOT NULL,
            created_at DATETIME NOT NULL,
            updated_at DATETIME NOT NULL,
            PRIMARY KEY(id),
            FOREIGN KEY(order_id) REFERENCES orders(id),
            FOREIGN KEY(item_id) REFERENCES items(id)
            );

INSERT INTO customers(id,name,address,created_at,updated_at) 
            VALUES(1,'A商事','東京都',now(),now()),
                  (2,'B商会','埼玉県',now(),now()),
                  (3,'C商店','神奈川県',now(),now());

INSERT INTO items(id,name,price,created_at,updated_at) 
            VALUES(1,'シャツ',1000,now(),now()),
                  (2,'パンツ',950,now(),now()),
                  (3,'マフラー',1200,now(),now()),
                  (4,'ブルゾン',1800,now(),now());

INSERT INTO orders(id,order_date,customer_id,created_at,updated_at) 
            VALUES(1 , '2013-10-01',1,now(),now()),
                  (2 , '2013-10-01',2,now(),now()),
                  (3 , '2013-10-02',2,now(),now()),
                  (4 , '2013-10-02',3,now(),now());

INSERT INTO order_details(order_id,item_id,item_quantity,created_at,updated_at) VALUES(1 , 1 ,3,now(),now()),(1 , 2 ,2,now(),now()),(2 , 1 ,1,now(),now()),(2 , 3 ,10,now(),now()),(2 , 4 ,5,now(),now()),(3 , 2 ,80,now(),now()),(4 , 3 ,25,now(),now());


SELECT     price * item_quantity
FROM       orders
INNER JOIN items
ON         order_details.item_id = items.id;

SELECT items.price * order_details.item_quantity 
FROM items 
INNER JOIN order_details 
ON items.id = order_details.item_id;
WHERE items.name = 'シャツ'


SELECT sum(a.price * b.item_quantity) proceeds 
FROM items a 
INNER JOIN 
order_details b 
ON (a.id = b.item_id)  
WHERE a.name = 'シャツ';


SELECT * 
FROM items 
ORDER BY rand() LIMIT 1;


SELECT DISTINCT order_details.order_id
FROM            order_details
INNER JOIN      items
ON              order_details.item_id = items.id
WHERE           items.name IN ('シャツ', 'パンツ')
ORDER BY        order_details.order_id DESC

SELECT od.order_id
FROM items i
INNER JOIN order_details od
ON i.id = od.item_id
WHERE items.name = 'シャツ'

複数のテーブルを結合するときの書き方
SELECT カラム名
FROM   テーブル名1
JOIN   テーブル名2
ON     テーブル名1.結合キー列 = テーブル名2.結合キー列
JOIN   テーブル名3
ON     テーブル名X.結合キー列 = テーブル名3.結合キー列


SELECT order_id
FROM (
      -- 商品IDと受注詳細の商品番号で内部結合
      -- 商品名がシャツの受注番号を抽出
      SELECT od.order_id
      FROM items i
      INNER JOIN order_details od
      ON i.id = od.item_id
      WHERE name = 'シャツ'
      UNION --商品番号が同じである受注番号がないため使える！！
      -- 商品IDと受注詳細の商品番号で内部結合
      -- 商品名がパンツの受注番号を抽出
      SELECT od.order_id
      FROM items i
      INNER JOIN order_details od
      ON i.id = od.item_id
      WHERE name = 'パンツ')
     ) od_i
ORDER BY order_id DESC;


--商品「シャツ」「パンツ」を受注した受注idを求めましょう
--受注idは新しい(大きい)順に並べましょう
SELECT od_i.order_id
FROM (
      SELECT od.order_id
      FROM items i
      INNER JOIN order_details od
      ON i.id = od.item_id
      WHERE i.name = 'シャツ'
      UNION
      SELECT od.order_id
      FROM items i
      INNER JOIN order_details od
      ON i.id = od.item_id
      WHERE i.name = 'パンツ'
      ) od_i
ORDER BY od_i.order_id DESC; --テーブル名つけても良い


SELECT     od.order_id
FROM       order_details od
INNER JOIN items i 
ON         od.item_id = i.id
WHERE      i.name IN ('シャツ', 'パンツ')
GROUP BY   od.order_id


SELECT     order_details.order_id
FROM       order_details
INNER JOIN items
ON         order_details.item_id = items.id
WHERE      items.name IN ('シャツ','パンツ')
GROUP BY   order_details.order_id
ORDER BY   order_details.order_id DESC;


SELECT     b.order_id 
FROM       items a 
INNER JOIN order_details b 
ON         a.id = b.item_id 
where      name in ('シャツ','パンツ') 
group by   b.order_id 
ORDER BY   b.order_id desc;

SELECT AVG(each_order_price.sum_price)
FROM   (
        SELECT     order_details.item_quantity * items.price sum_price
        FROM       order_details
        INNER JOIN items
        ON         order_details.item_id = items.id
        ) each_order_price;

SELECT SUM(each_order_price.sum_price)
FROM   (
        SELECT     order_details.item_quantity * items.price sum_price
        FROM       order_details
        INNER JOIN items
        ON         order_details.item_id = items.id
        ) each_order_price;


## Q4 受注全体から受注金額の平均を算出しましょう

SELECT AVG(each_sum_price.price)
FROM   (
        SELECT     od.order_id, od.item_quantity * i.price
        FROM       order_details od
        INNER JOIN items i
        ON         od.item_id = i.id
        GROUP BY   od.order_id
       ) each_sum_price


SELECT avg(sum_price) 
FROM (
      SELECT a.order_id,sum(b.price * a.item_quantity) sum_price 
      FROM order_details a 
      INNER JOIN items b 
      ON b.id = a.item_id 
      group by order_id
      ) c;

## 受注の件数も一緒に取得しましょう
SELECT AVG(sum_price_tbl.sum_price), count(sum_price_tbl.order_id)
FROM (
      SELECT     SUM(od.item_quantity * i.price) sum_price, od.order_id
      FROM       order_details od
      INNER JOIN items i
      ON         od.item_id = i.id
      GROUP BY   od.order_id
     ) sum_price_tbl;

SELECT order_id, sum_price
FROM (
      SELECT     SUM(od.item_quantity * i.price) sum_price, od.order_id
      FROM       order_details od
      INNER JOIN items i
      ON         od.item_id = i.id
      GROUP BY   od.order_id
     ) sum_price_tbl
WHERE sum_price_tbl.sum_price = 7600;


## 受注金額が一番大きい受注の受注idと受注金額を求めましょう
SELECT a.order_id,sum(b.price * a.item_quantity) order_price 
FROM order_details a 
INNER JOIN items b 
ON a.item_id = b.id 
GROUP BY a.order_id 
ORDER BY order_price DESC LIMIT 1;


SELECT     od.order_id, SUM(od.item_quantity * i.price) order_price
FROM       order_details od
INNER JOIN items i
ON         od.item_id = i.id
GROUP BY   od.order_id
ORDER BY   order_price DESC LIMIT 1;


## バルクインサート
INSERT INTO items (id, name,    price, created_at, updated_at)
            VALUES(1, 'シャツ',   1000, now(),      now()),
                  (2, 'パンツ',   950,  now(),      now()),
                  (3, 'マフラー', 1200, now(),      now()),
                  (4, 'ブルゾン', 1800, now(),      now());

INSERT INTO items (id, name, price, created_at, updated_at)
            VALUES(null, 'タンクトップ', 1300, now(), now()),
                  (null, 'ジャンパー', 2500, now(), now()),
                  (null, 'ソックス', 600, now(), now())

INSERT INTO items (name,         price)
            VALUES('シャツ',      1000),
                  ('パンツ',       950),
                  ('マフラー',    1200),
                  ('ブルゾン',    1800),
                  ('タンクトップ', 1300),
                  ('ジャンパー',   2500),
                  ('ソックス',     600);

SHOW columns FROM items;



DELETE FROM  items
       WHERE items.name = 'タンクトップ';


CREATE TABLE `items2` (
                    `id` INT(10) UNSIGNED AUTO_INCREMENT,
                    `name` VARCHAR(100) NOT NULL,
                    `price` INT(10) UNSIGNED NOT NULL,
                    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY (id)
                    );

INSERT INTO items2 (id, name,    price, created_at, updated_at)
            VALUES(1, 'シャツ',   1000, now(),      now()),
                  (2, 'パンツ',   950,  now(),      now()),
                  (3, 'マフラー', 1200, now(),      now()),
                  (4, 'ブルゾン', 1800, now(),      now());

INSERT INTO items2 (name, price)
            VALUES('タンクトップ', 1300, now(), now()),
                  ('ジャンパー', 2500, now(), now()),
                  ('ソックス', 600, now(), now())

SHOW columns FROM items


Q7 B商会の受注金額の合計を算出
(FROMはどこでも良い)
SELECT     SUM(od.item_quantity * i.price) sum_price
FROM       customers c
INNER JOIN orders o ON c.id = o.customer_id AND c.name = 'B商会'
INNER JOIN order_details od ON o.id = od.order_id
INNER JOIN items i ON od.item_id = i.id;

SELECT     SUM(od.item_quantity * i.price) AS sum_price
FROM       orders o
INNER JOIN order_details od ON o.id = od.order_id
INNER JOIN items i ON od.item_id = i.id
INNER JOIN customers c ON o.customer_id = c.id AND c.name = 'B商会'

SELECT SUM(od.item_quantity * i.price) AS sum_price
FROM   order_details od
INNER JOIN items i ON i.id = od.item_id
INNER JOIN orders o ON o.id = od.order_id
INNER JOIN customers c ON c.id = o.customer_id AND c.name = 'B商会'


Q8 商品(itemss)から受注明細(order_details)で使われている
   商品(items.id,items.name)を求めましょう、
   3 種類の SQL を作成しましょう

SELECT DISTINCT i.id, i.name
FROM items i
INNER JOIN order_details od ON od.item_id = i.id;

SELECT i.id, i.name
FROM   items i
WHERE  EXISTS ( -- 商品のIDが注文詳細の商品番号にある場合,trueを返す
       SELECT * FROM order_details od where i.id = od.item_id
);

SELECT *
FROM   scores s
WHERE  EXISTS ( -- 商品のIDが注文詳細の商品番号にある場合,trueを返す
       SELECT * FROM exams e 
       where e.score = s.item_id
       AND   e.score >= 80
);


SELECT s.id, s.user_id, s.exam_id, s.score
FROM   scores s
INNER JOIN exams e ON e.id = s.exam_id
WHERE s.score >= 80 AND s.exam_id != 1;
ORDER BY s.score DESC;

SELECT * COUNT()
FROM users u
INNER JOIN 


SELECT e.name, AVG(e.score), MAX(e.score)
FROM exams e
INNER JOIN scores s ON s.exam_id = e.id
GROUP BY e.name;


-- SELECT 社員番号, 氏名, 課コード, 内線番号
-- FROM   社員
-- WHERE  氏名 LIKE '%三%'

-- SELECT 　商品番号, SUM(注文番号)
-- FROM   　注文
-- GROUP BY 商品番号

-- SELECT   氏名
-- FROM     EMP
-- GROUP BY 氏名
-- HAVING   COUNT(*) >= 1


-- SELECT *
-- FROM EMP
-- WHERE EMP.DEPTNO = (
--   SELECT MIN(DEPT.DEPTNO)
--   FROM DEPT
-- )



-- SELECT 社員名
-- FROM	 社員の居室
-- WHERE	 居室番号 NOT IN (
--        SELECT 部屋番号
--        FROM	 部屋の管理部門
--        WHERE	 部門 = 'A1'
-- )


SELECT u.name user_name, e.name exam_name, c.name class_name, s.score
FROM users
INNER JOIN scores s ON s.user_id = u.id
INNER JOIN exmas e ON e.id = s.exam_id
INNER JOIN classes c ON c.id = e.class_id;


SELECT u.name user_name, e.name exam_name, c.name class_name, s.score
FROM users
INNER JOIN (
      SELECT user_id, exam_id, SUM(score) 
      FROM   scores
      GROUP BY user_id
)


SELECT u.name user_name, e.name exam_name, c.name class_name, s.score score
FROM users u
INNER JOIN scores s ON s.user_id = u.id
INNER JOIN exams e ON e.id = s.exam_id
INNER JOIN classes c ON c.id = e.class_id
WHERE s.score >= 90 AND u.id != 1;


-- 全てのユーザーと各ユーザーのテストの数

SELECT COUNT(*) num_of_users_exam
FROM   users u
CROSS JOIN scores s
GROUP BY u.id;

SELECT COUNT(*)
FROM   scores s
GROUP BY s.exam_id

SELECT COUNT(*)
FROM   


select "all_order" ,count(*) as count from order_details
union
select b.id , count(a.item_id) count
from order_details a right outer join items b on a.item_id = b.id  group by b.id;

-- TODO: 復習が必要！！！！
-- 合計体重が１０００以下になるようにデータを取得（列順）
SELECT accumulated_tbl.name
FROM (
      SELECT name, SUM(weight) OVER(ORDER BY turn) accumulated_weight
      FROM   line
) AS accumulated_tbl
WHERE accumulated_tbl.accumulated_weight <= 1000
ORDER BY accumulated_weight desc limit 1


SELECT `interviews`.* 
FROM `interviews` 
WHERE `interviews`.`job_id` = 1 LIMIT 11
