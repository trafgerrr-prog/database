--МНОГОТАБЛИЧНЫЕ ЗАПРОСЫ--
--1--
SELECT st.name, st.surname, h.name
FROM student st,
     student_hobby sh,
	 hobby h
WHERE st.id = sh.student_id AND h.id = sh.hobby_id
--2--
SELECT s.*, sh.date_start, sh.date_finish
FROM student s,
	 student_hobby sh,
	 hobby h
WHERE date_finish IS NULL AND s.id = sh.student_id AND h.id = sh.hobby_id
ORDER BY sh.date_start
LIMIT 1
--3--
SELECT distinct s.name, s.surname, s.date_birth
FROM student s,
	 hobby h,
	 student_hobby sh,
	(SELECT avg(score)::real as sr
	  FROM student ) as foo1,
	(SELECT sum(risk) as sm, s.id
	  FROM student s,
	  hobby h,
	  student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  GROUP BY s.id) as foo2
WHERE sr <= s.score AND s.id = sh.student_id AND h.id = sh.hobby_id AND sm >= 0.9 AND s.id = foo2.id
--4--
SELECT s.name, s.surname, s.date_birth, h.name as name_hobby, extract(month from age(sh.date_finish, sh.date_start)) as month
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE date_finish IS NOT NULL AND s.id = sh.student_id AND h.id = sh.hobby_id
--5--
SELECT distinct s.name, s.surname, s.date_birth
FROM student s,
	 (SELECT s.id, count(h.name)
	  FROM student s, 
	 	   hobby h, 
	       student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  GROUP BY s.id) as foo, 
	  hobby h, 
	  student_hobby sh
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND 
	  foo.count > 1 AND foo.id = s.id AND extract(year from age(now(), s.date_birth)) >= 10
--6--
SELECT avg(score)::real, s.ngroup
FROM student s,
	 hobby h,
	 student_hobby sh,
	 (SELECT s.id, count(h.name)
	  FROM student s, 
	 	   hobby h, 
	       student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND sh.date_finish IS NULL
	  GROUP BY s.id) as foo
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND foo.id = s.id AND foo.count >= 1
GROUP BY s.ngroup
--8--
SELECT distinct h.name
FROM student s,
	 hobby h,
	 student_hobby sh,
	 (SELECT max(score)
	  FROM student
	  GROUP BY ngroup
	  ORDER BY max DESC
	  LIMIT 1) as foo
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND s.score = foo.max
--9--
SELECT h.name
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND CAST(ngroup AS VARCHAR) like '2%' AND score > 2.51 AND score < 3.5
--11--
SELECT distinct foo1.ngroup
FROM (SELECT ngroup, (count(*)*0.6) as count
	  FROM student
	  GROUP BY ngroup
	  ORDER BY ngroup) as foo1,
	 (SELECT ngroup, count(*) 
	  FROM student
	  WHERE score >= 4
	  GROUP BY ngroup
	  ORDER BY ngroup) as foo2
WHERE foo1.count <= foo2.count AND foo1.ngroup = foo2.ngroup
--14--
CREATE OR REPLACE VIEW Students_V1 AS
SELECT s.*
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND sh.date_finish IS NULL AND extract(year from age(now(), sh.date_start)) >= 5
--15--
SELECT h.name, count(*)
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id = sh.student_id AND h.id = sh.hobby_id
GROUP BY h.name
ORDER BY count DESC
--16--
SELECT foo.id
FROM (SELECT h.id, count(*)
	  FROM student s,
	 	   hobby h,
	 	   student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  GROUP BY h.id
	  ORDER BY count DESC
	  LIMIT 1) as foo
--17--
SELECT s.*
FROM student s,
	 hobby h,
	 student_hobby sh,
	 (SELECT h.id, count(*)
	  FROM student s,
	 	   hobby h,
	 	   student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  GROUP BY h.id
	  ORDER BY count DESC
	  LIMIT 1) as foo
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND foo.id = h.id
--18--
SELECT foo.id
FROM (SELECT distinct h.id, h.risk
	  FROM student s,
	 	   hobby h,
	 	   student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  ORDER BY h.risk DESC
	  LIMIT 3) as foo
--19--
SELECT distinct s.id, s.name, s.surname, time.age, h.name
FROM (SELECT age(now(), date_start), s.id, sh.hobby_id
	  FROM student s,
	  hobby h,
	  student_hobby sh
	  WHERE date_finish IS NULL and s.id = sh.student_id AND h.id = sh.hobby_id) as time,
	 student s,
	 hobby h,
	 student_hobby sh
WHERE s.id = sh.student_id AND h.id = sh.hobby_id and time.id = s.id and time.hobby_id = sh.hobby_id
ORDER BY age DESC
LIMIT 10
--20--
SELECT distinct s.ngroup
FROM student s,
	 (SELECT distinct s.id, s.name, s.surname, time.age, h.name
	  FROM (SELECT age(now(), date_start), s.id, sh.hobby_id
	  		FROM student s,
	  			 hobby h,
	  			 student_hobby sh
	  		WHERE date_finish IS NULL and s.id = sh.student_id AND h.id = sh.hobby_id) as time,
	 		student s,
	 		hobby h,
	 		student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id and time.id = s.id and time.hobby_id = sh.hobby_id
	  ORDER BY age DESC
	  LIMIT 10) as foo
WHERE s.id = foo.id
--21--
CREATE OR REPLACE VIEW Students_V2 AS
SELECT s.id, s.name, s.surname
FROM student s
ORDER BY s.score DESC
--25(18)--
CREATE OR REPLACE VIEW Hobby_V1 AS
SELECT foo.name
FROM (SELECT h.name, count(*)
	  FROM student s,
	 	   hobby h,
	 	   student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  GROUP BY h.id
	  ORDER BY count DESC
	  LIMIT 1) as foo
--29--
SELECT s.date_birth, count(h.name)
FROM student s,
	 hobby h,
	 student_hobby sh
WHERE s.id = sh.student_id AND h.id = sh.hobby_id
GROUP BY s.date_birth
--31--
SELECT foo.month, avg(s.score)::real
FROM student s,
	 hobby h,
	 student_hobby sh,
	 (SELECT s.id, date_part('month', s.date_birth) as month
	  FROM student s) as foo
WHERE s.id = sh.student_id AND h.id = sh.hobby_id AND h.name = 'Футбол' AND foo.id = s.id
GROUP BY foo.month
--32--
SELECT distinct s.name, s.surname, s.ngroup
FROM student s,
	 hobby h,
	 student_hobby sh,
	 (SELECT s.id, count(h.name)
	  FROM student s,
	 	   hobby h,
	  	   student_hobby sh
	  WHERE s.id = sh.student_id AND h.id = sh.hobby_id
	  GROUP BY s.id) as foo
WHERE s.id = foo.id AND foo.count >= 1 AND s.id = sh.student_id AND h.id = sh.hobby_id


