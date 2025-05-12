
https://stepik.org/course/63054/syllabus



1. Создание таблицы

         CREATE TABLE book(
            book_id INT PRIMARY KEY AUTO_INCREMENT,
            title VARCHAR(50),
            author VARCHAR(30),
            price DECIMAL(8,2),
            amount INT
        );




2.  Cоздание таблицы на основе данных из другой таблицы

            CREATE TABLE ordering AS
            SELECT author, title, 5 AS amount
            FROM book
            WHERE amount < 4;

            SELECT * FROM ordering;






1. Создание таблицы с внешними ключами


/*
        С помощью выражения ON DELETE можно установить действия, которые выполняются для записей подчиненной таблицы при удалении связанной строки из главной таблицы. При удалении можно установить следующие опции:

        - CASCADE:      автоматически удаляет строки из зависимой таблицы при удалении  связанных строк в главной таблице.
        - SET NULL:     при удалении  связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение NULL. (В этом случае столбец внешнего ключа должен поддерживать установку NULL).
        - SET DEFAULT   похоже на SET NULL за тем исключением, что значение  внешнего ключа устанавливается не в NULL, а в значение по умолчанию для данного столбца.
        - RESTRICT:     отклоняет удаление строк в главной таблице при наличии связанных строк в зависимой таблице.

        Важно! Если для столбца установлена опция SET NULL, то при его описании нельзя задать ограничение на пустое значение.
 */


                    CREATE TABLE book (
                        book_id INT PRIMARY KEY AUTO_INCREMENT,
                        title VARCHAR(50),
                        price DECIMAL(8,2),
                        amount INT,

                            /*
                            По умолчанию любой столбец, кроме ключевого, может содержать значение NULL. При создании таблицы это можно переопределить,  используя  ограничение NOT NULL для этого столбца
                            Для внешних ключей рекомендуется устанавливать ограничение NOT NUL, при  ON DELETE (не равным SET NULL)
                            */
                        author_id INT NOT NULL,
                        genre_id INT,

                            /*
                            внешний ключ:
                            главная таблица author, связанный столбец author.author_id,

                            FOREIGN KEY (связанное_поле_зависимой_таблицы)
                            REFERENCES главная_таблица (связанное_поле_главной_таблицы)
                            */
                        FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
                        FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
                    );














2. Вставка записи

        INSERT INTO book (title, author, price, amount)
        VALUES
            ('Война и мир','Толстой Л.Н.', 1070.20, 2),
            ('Анна Каренина', 'Толстой Л.Н.', 599.90, 3);




3. Добавление записей из другой таблицы  (Количество, порядок, типы полей должны совпадать)

        INSERT INTO book (title, author, price, amount)
        SELECT title, author, price, amount
        FROM supply;



        INSERT INTO author (name_author)
        SELECT supply.author
        FROM supply LEFT JOIN author ON  author.name_author = supply.author
        WHERE   author.name_author is null


        INSERT INTO attempt
            (student_id, subject_id, date_attempt)
        values (
            (select  student_id from student where name_student='Баранов Павел'),
            (select  subject_id from subject where name_subject='Основы баз данных'),
                NOW()
        );










4. Обновление

        UPDATE book
        SET price = 0.7 * price,
            buy = 0
        WHERE amount < 5;




Обновление с подзапросом

        UPDATE book
        SET genre_id =
              (
               SELECT genre_id
               FROM genre
               WHERE name_genre = 'Роман'
              )
        WHERE book_id = 9;





4. Обновление нескольких таблиц

Исправлять данные можно во всех используемых в запросе таблицах.

        UPDATE book, supply
        SET book.amount = book.amount + supply.amount
        WHERE book.title = supply.title AND book.author = supply.author;




        UPDATE fine,
            (
                 SELECT name, number_plate, violation
                 FROM fine
                 GROUP BY name, number_plate, violation
                 having count(*) > 1
            ) query_in
        SET fine.sum_fine = fine.sum_fine * 2
        WHERE fine.name = query_in.name and date_payment is null;





        UPDATE book
             INNER JOIN author ON author.author_id = book.author_id
             INNER JOIN supply ON book.title = supply.title
                                 and supply.author = author.name_author
        SET book.amount = book.amount + supply.amount,
            supply.amount = 0
        WHERE book.price = supply.price;

        SELECT * FROM book;
        SELECT * FROM supply;
















5. Удаление

        DELETE FROM supply
        WHERE author IN (
            SELECT author
            FROM book
            group by author
            having sum(amount) > 10
            );



        Удаление записей, использование связанных таблиц

            DELETE FROM author
            USING
                author
                INNER JOIN book ON author.author_id = book.author_id
            WHERE book.amount < 3;





        Сложный запрос с алиасами

            delete from a

            using
                applicant a
                inner join enrollee e on a.enrollee_id = e.enrollee_id
                inner join program_enrollee pe on e.enrollee_id = pe.enrollee_id
                inner join program p on p.program_id = pe.program_id
                inner join program_subject ps on ps.program_id = p.program_id
                inner join subject s on s.subject_id = ps.subject_id
                inner join enrollee_subject es
                        on s.subject_id = es.subject_id
                        and e.enrollee_id = es.enrollee_id

            where es.result < ps.min_result
                and e.enrollee_id = a.enrollee_id
                and p.program_id = a.program_id







        Используйте DROP, если:

            - Нужно полностью удалить таблицу (или другую структуру) из базы данных.
            - Больше не требуется использовать эту таблицу.

        Используйте DELETE, если:

            - Нужно удалить только определенные строки (с условием WHERE).
            - Важно сохранить возможность отката изменений.
            - Таблица имеет внешние ключи.

        Используйте TRUNCATE, если:

            - Нужно быстро удалить все строки из таблицы.
            - Необходимо сбросить значения автоинкремента.
            - Таблица не имеет внешних ключей или они временно отключены.











6.  ALTER TABLE

    Для вставки нового столбца используется SQL запросы:

            ALTER TABLE таблица ADD имя_столбца тип; - вставляет столбец после последнего
            ALTER TABLE таблица ADD имя_столбца тип FIRST; - вставляет столбец перед первым
            ALTER TABLE таблица ADD имя_столбца тип AFTER имя_столбца_1; - вставляет столбец после укзанного столбца


    Для удаления столбца используется SQL запросы:

            ALTER TABLE таблица DROP COLUMN имя_столбца; - удаляет столбец с заданным именем
            ALTER TABLE таблица DROP имя_столбца; - ключевое слово COLUMN не обязательно указывать
            ALTER TABLE таблица DROP имя_столбца,
                                DROP имя_столбца_1; - удаляет два столбца


    Для переименования столбца используется  запрос (тип данных указывать обязательно):

            ALTER TABLE таблица CHANGE имя_столбца новое_имя_столбца ТИП ДАННЫХ;

    Для изменения типа  столбца используется запрос (два раза указывать имя столбца обязательно):

            ALTER TABLE таблица CHANGE имя_столбца имя_столбца НОВЫЙ_ТИП_ДАННЫХ;






7. Переменные

        SET @row_num := 0;

        SELECT *, (@row_num := @row_num + 1) AS str_num
        FROM  applicant_order;


    Присваивание переменной происходит на каждой записи

        SET @num_pr := 0;
        SET @row_num := 1;

        SELECT *,
             if(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1) AS str_num,
             @num_pr := program_id AS add_var
        from applicant_order;










