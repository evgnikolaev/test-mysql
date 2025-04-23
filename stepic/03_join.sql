
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


        Вложенные запросы  могут включаться в WHERE или HAVING так (в квадратных скобках указаны необязательные элементы, через | – один из элементов):

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












2.1       !!!!!!!!!!!!!!!
https://stepik.org/lesson/308885/step/1?unit=291011










