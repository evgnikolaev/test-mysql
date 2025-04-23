
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




2. Вставка записи

        INSERT INTO book (title, author, price, amount)
        VALUES
            ('Война и мир','Толстой Л.Н.', 1070.20, 2),
            ('Анна Каренина', 'Толстой Л.Н.', 599.90, 3);




3. Добавление записей из другой таблицы  (Количество, порядок, типы полей должны совпадать)

        INSERT INTO book (title, author, price, amount)
        SELECT title, author, price, amount
        FROM supply;

        SELECT * FROM book;




4. Обновление

        UPDATE book
        SET price = 0.7 * price,
            buy = 0
        WHERE amount < 5;




4. Обновление нескольких таблиц


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




5. Удаление

        DELETE FROM supply
        WHERE author IN (
            SELECT author
            FROM book
            group by author
            having sum(amount) > 10
            );








