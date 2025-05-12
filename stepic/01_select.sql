
https://stepik.org/course/63054/syllabus



1. Выборка с вычисляемым столбцом

        SELECT title AS Название, author AS Автор,
           ROUND(price*0.7,2) AS new_price
        FROM book;




2. Выборка с вычисляемым столбцом и логической ф-ией

        IF(логическое_выражение, выражение_1 - для истины , выражение_2 - для ложь  )

        SELECT title, amount, price,

             IF(amount < 4, price * 0.5,
                 IF(amount < 11, price * 0.7, price * 0.9)),
             AS sale,

        FROM book;





3. Выборка данных по условию

        Приоритеты операций:
        1. круглые скобки
        2. умножение  (*),  деление (/)
        3. сложение  (+), вычитание (-)
        4. операторы сравнения (=, >, <, >=, <=, <>)
        5. BETWEEN и IN
        6. NOT
        7. AND
        8. OR


        SELECT title, author, price
        FROM book
        WHERE price > 600 AND author = 'Булгаков М.А.';
        /* WHERE price BETWEEN 540.50 AND 800 AND amount IN (2,3,5,7); */
        ORDER BY author DESC, title ASC;




4. Выборка данных, оператор LIKE


        % 	Любая строка, содержащая ноль или более символов
        _   (подчеркивание) Любой одиночный символ


        SELECT * FROM book
        WHERE author LIKE '%М.%'
        /* выполняет поиск и выдает все книги, инициалы авторов которых содержат «М.» */


        SELECT * FROM book
        WHERE title LIKE 'Поэм_'
        /* выполняет поиск и выдает все книги, названия которых либо «Поэма», либо «Поэмы» и пр. */





5. Выбор уникальных элементов столбца

        SELECT DISTINCT author
        FROM book;




6. Групповые функции SUM(), COUNT(), MIN(), MAX(), AVG()

        COUNT(*) -  подсчитывает  все записи, относящиеся к группе, в том числе и со значением NULL;
        COUNT(имя_столбца) - возвращает количество записей конкретного столбца (только NOT NULL), относящихся к группе.
        COUNT(столбец)                    - количество значений в столбце
        COUNT(DISTINCT столбец) - количество уникальных значений в столбце


        GROUP BY - группировка по столбцу
        HAVING   - условие отбора строк групповых выборках



                        SELECT author,
                               count(amount),
                               MIN(price) AS Минимальная_цена,
                               MAX(price) AS Максимальная_цена,
                               SUM(price * amount) AS Стоимость
                        FROM book
                        GROUP BY author
                        HAVING SUM(price * amount) > 5000;





                        SELECT SUM(amount) AS Количество
                        FROM book;
                        /* Вычисления по таблице целиком */




7. Группировка данных по нескольким столбцам

        В разделе GROUP BY можно указывать несколько столбцов, разделяя их запятыми. Тогда к одной группе будут относиться записи, у которых значения столбцов, входящих в группу, равны.

        SELECT name, number_plate, violation, count(*)
        FROM fine
        GROUP BY name, number_plate, violation;






8. Вложенный запрос

        Его применяют для:
            - сравнения выражения с результатом вложенного запроса;
            - определения того, включено ли выражение в результаты вложенного запроса;
            - проверки того, выбирает ли запрос определенные строки.


        Вложенный запрос может быть включен:  после ключевого слова SELECT,  после FROM и в условие отбора после WHERE (HAVING).

            - WHERE | HAVING выражение оператор_сравнения (вложенный запрос);


                            SELECT title, author, price, amount
                            FROM book
                            WHERE price = (
                                SELECT MIN(price)
                                FROM book
                                );


            - WHERE | HAVING выражение, включающее вложенный запрос;

                            SELECT title, author, amount
                            FROM book
                            WHERE ABS(amount - (SELECT AVG(amount) FROM book)) >3;



            - WHERE | HAVING выражение [NOT] IN (вложенный запрос);

                            SELECT title, author, amount, price
                            FROM book
                            WHERE author IN (
                                SELECT author
                                FROM book
                                GROUP BY author
                                HAVING SUM(amount) >= 12
                                );



            - WHERE | HAVING выражение  оператор_сравнения  ANY | ALL (вложенный запрос).

                            SELECT title, author, amount, price
                            FROM book
                            WHERE amount < ALL (
                                    SELECT AVG(amount)
                                    FROM book
                                    GROUP BY author
                                  );




            - Вложенный запрос после SELECT

                            SELECT title, author, amount,
                                   (
                                       SELECT AVG(amount)
                                       FROM book
                                       ) AS Среднее_количество
                            FROM book
                            WHERE abs(amount - (SELECT AVG(amount) FROM book)) >3;
















9. Соединение INNER JOIN

/*
    INNER JOIN                  - Порядок таблиц для оператора неважен, поскольку оператор является симметричным.
    LEFT JOIN  и RIGHT JOIN     - Порядок таблиц для оператора важен, поскольку оператор не является симметричным.
*/


               SELECT title, name_author
                FROM
                    author INNER JOIN book                    /* таблица_1 INNER JOIN   таблица_2 */
                    ON author.author_id = book.author_id;     /* ON условие */



/*
    CROSS JOIN   - Порядок таблиц для оператора неважен, поскольку оператор является симметричным.
    Результат запроса формируется так: каждая строка одной таблицы соединяется с каждой строкой другой таблицы, формируя в результате все возможные сочетания строк двух таблиц.

            SELECT                                                              SELECT
             ...                                                                ...
            FROM                                             =>                 FROM
                таблица_1 CROSS JOIN  таблица_2                                     таблица_1, таблица_2
                ...                                                                 ...
*/


                SELECT name_author, name_genre
                FROM
                    author, genre;




/*
    Операция соединение, использование USING()

    Если база данных хорошо спроектирована, а каждый внешний ключ имеет такое же имя, как и соответствующий первичный ключ (например, genre.genre_id = book.genre_id), тогда можно использовать предложение USING для реализации операции JOIN.
    Запросы ниже идентичны.
*/

                SELECT title, name_author, author.author_id /* явно указать таблицу - обязательно */
                FROM
                    author INNER JOIN book
                    ON author.author_id = book.author_id;


                SELECT title, name_author, author_id /* имя таблицы, из которой берется author_id, указывать не обязательно*/
                FROM
                    author INNER JOIN book
                    USING(author_id);


/*
Оператор UNION UNION ALL

Оператор UNION используется для объединения двух и более SQL запросов, его синтаксис:
Важно отметить, что каждый из SELECT должен иметь в своем запросе одинаковое количество столбцов и  совместимые типы возвращаемых данных.

UNION       - без повторений (без дублирующих записей, уникальные):
UNION ALL   - с повторением
*/


            SELECT name_client
            FROM
                buy_archive
                INNER JOIN client USING(client_id)

            UNION

            SELECT name_client
            FROM
                buy
                INNER JOIN client USING(client_id)









10. Запросы для нескольких таблиц со вложенными запросами
Вложенный запрос может быть включен:  после ключевого слова SELECT,  после FROM и в условие отбора после WHERE (HAVING).


Вывести авторов, общее количество книг которых на складе максимально.


            SELECT name_author, SUM(amount) as Количество
            FROM
                author INNER JOIN book
                on author.author_id = book.author_id
            GROUP BY name_author
            HAVING SUM(amount) =
                 (/* вычисляем максимальное из общего количества книг каждого автора */
                  SELECT MAX(sum_amount) AS max_sum_amount
                  FROM
                      (/* считаем количество книг каждого автора */
                        SELECT author_id, SUM(amount) AS sum_amount
                        FROM book GROUP BY author_id
                      ) query_in
                  );




Вложенные запросы в операторах соединения
Вывести авторов, пишущих книги в самом популярном жанре (бщее количество экземпляров книг которого на складе максимально)

            SELECT  name_author, name_genre
            FROM
                author
                INNER JOIN book ON author.author_id = book.author_id
                INNER JOIN genre ON  book.genre_id = genre.genre_id
            GROUP BY name_author,name_genre, genre.genre_id
            HAVING genre.genre_id IN
                     (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
                      SELECT query_in_1.genre_id
                      FROM
                          ( /* выбираем код жанра и количество произведений, относящихся к нему */
                            SELECT genre_id, SUM(amount) AS sum_amount
                            FROM book
                            GROUP BY genre_id
                           ) query_in_1
                      INNER JOIN
                          ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг (так как их может быть несколько) */
                            SELECT genre_id, SUM(amount) AS sum_amount
                            FROM book
                            GROUP BY genre_id
                            ORDER BY sum_amount DESC
                            LIMIT 1
                           ) query_in_2
                      ON query_in_1.sum_amount= query_in_2.sum_amount
                     );





11. Закольцованная связь много ко многим ()

 /* ! join по 2-м полям(чтобы не подсоединять результаты всех людей")  */

            select name_program, name_enrollee, sum(result) as itog
            from enrollee
                inner join program_enrollee using(enrollee_id)
                inner join program using(program_id)
                inner join program_subject using(program_id)
                inner join subject using(subject_id)
                inner join enrollee_subject on
                        subject.subject_id = enrollee_subject.subject_id
                        and enrollee_subject.enrollee_id = enrollee.enrollee_id

            group by name_program, name_enrollee
            order by name_program, itog desc






12. join-ить можно и вложенные таблицы

            update
                applicant app
                inner join
                    (
                        select ea.enrollee_id,  sum(a.bonus) as dop
                        from enrollee_achievement ea
                            inner join achievement a on ea.achievement_id = a.achievement_id
                        group by ea.enrollee_id

                    ) as bonus
                        on app.enrollee_id =  bonus.enrollee_id

            SET app.itog = app.itog + bonus.dop






LEFT("abcde", 3) -> "abc"     Чтобы выделить крайние левые n символов из строки используется функция LEFT(строка, n):
CONCAT("ab","cd") -> "abcd"   Соединение строк осуществляется с помощью функции CONCAT(строка_1, строка_2):
 NOW() текущую дату



