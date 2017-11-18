create temp table users(id bigserial, group_id bigint);
insert into users(group_id) values (1), (1), (1), (2), (1), (3);

--     1    В этой таблице, упорядоченой по ID необходимо:
--     2    выделить непрерывные группы по group_id с учетом указанного порядка записей (их 4)
--     3    подсчитать количество записей в каждой группе
--     4    вычислить минимальный ID записи в группе

--     2    выделить непрерывные группы по group_id с учетом указанного порядка записей (их 4)
SELECT users.id, users.group_id, seq
FROM
  (
    SELECT users.*, (CASE WHEN lead(users.group_id) OVER (ORDER BY users.id) = users.group_id THEN 1 ELSE 0 END) AS seq
    FROM users
  ) AS users
ORDER BY users.id;

--     3    подсчитать количество записей в каждой группе
SELECT users.group_id, COUNT(users.id)
FROM users
GROUP BY users.group_id;

--     4    вычислить минимальный ID записи в группе
SELECT users.group_id, MIN(users.id)
FROM users
GROUP BY users.group_id;
