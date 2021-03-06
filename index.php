<? /*

2) установка
https://dev.mysql.com/downloads/ - установка для windows
mysql workbench - графический клиент для доступа к БД.


3) Проектирование БД. Нормальные формы
 В БД количество столбцов всегда ограничено.

Нормальные формы или правила:
	1 нормальная форма:
		- Все элементы внутри ячеек должны быть не списками, атомарными( его нельзя разделить на части )
		- Все строчки должны быть различними (для этого вводится первичный уникальный ключ - артикул, ID), чтобы отделить одну строку от другого.

	2 нормальная форма:
		- Любое поле, не входящее в состав первичного ключа, функционально полно зависит от первичного ключа.
		  (создаем еще таблицу для определенной сущности, можно добавлять новые поля для таблицы новой сущности, относящиеся только к этой сущности)

	3 нормальная форма:
		- таблица удовлетворяет 3-ей нормальной форме, если любой ее неключевой атрибут функционально зависит только от первичного ключа.
		  (создаем еще таблицу для определенной сущности) . Проставленные связки - это вторичные ключи.
		   Все дублирующие названия сттрок, выносим в отдельную таблицу.



4)	phpmyadmin - удобный интерфейс, чтобы из консоли не работать.

	По умолчанию всегда будут 2 служебные базы (их не трогаем)
		information_schema
		performance_schema

	1) создаем БД в кодировке - utf8_general_ci.
		Под каждую сущность создаем таблицу.

		--- СВОЙСТВА СТОЛБЦА ТАБЛИЦЫ ---
			имя 			- название столбца
			тип 			- тип столбца
			длина/значение 	- можем ограничить по длине значение столбца
			по умолчанию 	- значение по умолчанию для столбца, если не задали значение
			сравнение		- можем отдельно задать кодировку для столбца, например китайское слово
			атрибуты		- 	binary  						- бинарное значение
						  	unsigned 						- положительное
							unsugned zerofil 				- положительное с лидирующим нулем (01,02 ...)
							on update current timestamp		- текущий timestamp при создании по умолчанию
			null 			- можно ли в столбец сохранить null (обычно для необязательных полей, если не передали, то будет null)
			индекс			- облегчают поиск по базе.
							БД создает отдельное хранилище, и ищется по нему.
							INDEX - простой индекс
							PRIMARY - primary key
							UNIQUE - уникальный

			AI				- столбец автоинкрементный
			комментарии		- комментарий для столбца таблицы
			виртуальность	    - не трогаем
			MIME-тип		- дополнительно, для типа столбца BLOB - для хранения целых файлов. Но так никто не делает в вебе, в других приложениях может быть нужно.


		--- СВОЙСТВА САМОЙ ТАБЛИЦЫ ---:
			Комментарий к таблице.
			Сравнение  		- можно задать кодировку для все таблицы
			Тип таблиц 		- 	InnoDB - быстро искать, добавлять. Отдача медленнее чем MyISAM. Используем его.
					 			MyISAM - рассчитан на максимальную отдачу данных. Добавление, удаление изменение долгое. Используют для проектов как справочники. Один раз внесли, дальше просто отдача данных. Не поддерживает транзакции, индекс, ключи. Устарел.
			Определение разделов PARTITION - сюда не лезем.

				CREATE TABLE `shop_test`.`category` ( `id` INT NOT NULL AUTO_INCREMENT , PRIMARY KEY (`id`)) ENGINE = InnoDB;

				use `shop_test`; - выбираем БД, чтобы с ней работать и в последующем БД не указывать.
				--     - это комментарий стрки

5)      Вставка
		INSERT INTO `БД`.`таблица` (`поля`) VALUES (`значения`) - неиспользуемые поля можно не писать
		Можно добавить несколько записей за раз
		INSERT INTO `shop_test`.`category` ( `title`,`content` ) VALUES ('второй пост','контент2'), ('третий пост','контент3')
		insert into `brand` (`type`) VALUES ('test');


6) Выборка
		SELECT `поля таблицы` FROM `таблица` WHERE `предикат - наборы условий к каждого столбца`   - кавычки можно ставить, можно и нет
		SELECT *, title, content FROM `post` WHERE id >=0                   -- * (все поля)
												id = 1
												id 	!= 1
												id IS NULL     			(проверка на NULL)
												id IS NOT NULL
												id BETWEEN 1 and 10 	(между)
												id IN (1,15,25)			(любое из)
												id NOT IN (1,15,25)
												title LIKE '%мой%'		(содержит "мой")
												title NOT LIKE '%мой%'
												title NOT LIKE '%мой%' AND pub_date>564245  (Логическое И)
												AND OR  NOT - Логические операторы
                                                NOT (discount < 5)


7) Выборка

	DISTINCT поле  - только уникальные для поля
	SELECT DISTINCT `discount` FROM category

    ORDER BY - сортировка
    SELECT `id`,`discount`,`name` FROM category  ORDER BY discount DESC

	LIMIT - ограничиваем выборку, только первые 2
	SELECT * FROM category  ORDER BY discount ASC LIMIT 2




8) Замена
		!!!! если не указать условие , погубиться вся таблица !!!!
		UPDATE `таблица` SET `поля` WHERE `предикат - наборы условий к каждой записи`
		UPDATE `post` SET `title`='title11' WHERE `id`=1


		Удаление
		!!!! если не указать условие , погубиться вся таблица !!!!
		DELETE FROM `таблица` WHERE `предикат - наборы условий к каждой записи`
		DELETE FROM `post` WHERE id=1


 Для безопасного удаления изменения есть настройка БД,
 позволяющая удалять иизменять, только когда в предикате исползуется первичный ключ (например id)
 (Только она похоже проставляется для определенного ползователя или клиента!)
	SHOW VARIABLES LIKE 'sql_safe_updates'; - посмотреть
	SET sql_safe_updates=1;
	SET sql_safe_updates=0;



9)		Внешний ключ:
		 - Консистентность (согласованность данных)
                Несогласованоость - это когда привязки не совпадают, например brand_id=7, а 7-го элемента нет.
         - foreign key constraints (внешние ключи)


10) Внешние ключи
        файл - таблицы.jpg .

		Для того чтобы не было несогласованности данных, используем внешние ключи.
		Внешний ключ - нужен для целостности данных, для связей на уровне базы. Облегчают работу.
		"Физическая связь" - связь между двумя таблицами. Есть родительская таблица и есть дочерняя таблица.
		В зависимости как мы настроили внешний ключ, мы можем изменить данные в дочерней талице.
        !!! Перед тем как задать внешние ключи, таблица должна быть в консистентном состоянии, иначе будет ошибка.

		Например brand.id будет связан с product.brand_id.
		!!Переходим в таблицу product->структура->связи(внешние ключи), так как brand_id будет внешним ключом.
        И задаем название ключа и связи таблиц (при помощи ALTER TABLE ...  ADD CONSTRAINT ... - создастся внешний ключ)
		И задаем ограничения, что делать при удалении, что делать при изменении:
		cascade		- каскадное обновление, если мы изменим id бренда на 22, то и brand_id автоматически измениться на 22
					  при удалении родителя, удаляться и дочерние связанные данные.
		set null	- установить в поле null, (должна быть устновлена галочка null на поле)
		no action	- ничего не делать (не даст удалить/изменить)
		restrict	- нельзя удалить/изменить из родительской талицы связанное поле (уже на уровне базы не даст удалить связанное поле)

		Все зависит от того что нужно делать.
		Если нужно обновлять данные - cascade.
		Если нужно сохранить данные - restrict (в этом случае добавляем поле статус).
		Если все равно - set null.
		Мы же в блоге будем все делать "cascade".


		Есть еще "логическая связь" помимо физической:
		1) один к одному - обычно редко исползуется, в этом случае можно просто объединить 2 таблицы в большинстве случаев.
		2) один ко многим - бренд к продукту
		3) многие ко многим - для этой связи исползуется промежуточная таблица.



        "объяснение логических связей 1.jpg"   "объяснение логических связей 2.png"
		!!! Внешние ключи ставятся на стороне много !!!
        Объяснение логических связей:
        1) Один ко многим
           Кафедра 1-N Студент
                - На скольких кафедрах учится студент (на одном)
                - Сколько студентов на одной кафедре (много)
		   Кафедра 1-N Препод
				- На скольких кафедрах числится преподаватель (на одном)
                - Сколько преподавателей на кафедре (много)

        2) Один к одному
           Кафедра 1-1 Зав Кафедры
				- Сколько зав кафедр на кафедре (один)
                - Сколькими кафедрами может заведовать зав кафедры (одним)

       3) много ко многим
            Студент N-N Предмет
                - Сколько студентов может быть на одном прдемете (много)
                - Сколько предметов может быть у одного студента (много)

            Для этого создается промежуточная таблица, где храняться внешние ключи для обоих таблиц.
            При этом каждая строка уникальна, и создается составной первичный ключ из двух внешних ключей.


		!!!! Логические связи мы используем при создании/заполнении страниц, а с помощью join (объединение таблиц по полям) мы уже выводим существующие данные.



 11-12) Отношение многие ко многим
			"11 много ко многим.jpg"
            Для этого создается промежуточная таблица order_product, где храняться внешние ключи для обоих таблиц.
            При этом каждая строка уникальна, и создается СОСТАВНОЙ первичный ключ из двух внешних ключей.
			Делаем пара значений order_id и product_id первичными ключами.


13) Объединение данных из нескольких таблиц
	 1 способ: Неправильный - делать много запросов, и после собирать данные.
        SELECT * from product;
		SELECT * FROM category WHERE id IN(1,2,3);
		SELECT * FROM brand WHERE id=1;


14) inner join  -  выборка по пересечению таблиц.

		SELECT * FROM product INNER JOIN category ON  product.category_id = category.id

    Объединять можно сколько угодно таблиц.
		SELECT
			product.id,
			brand.name AS brand_name,  -- псевдоним столбца
			product_type.type,
			category.name AS category_name,
			product.price,
			category.discount
		FROM product
			INNER JOIN category ON  product.category_id = category.id       -- к таблице продуктов приклеиваем таблицу категорий
			INNER JOIN brand ON  product.brand_id = brand.id                --  к общей получившейся таблице, приклеиваем таблицу бренды
			INNER JOIN product_type ON product.type_id = product_type.id    --  к общей получившейся таблице, приклеиваем таблицу типов
		WHERE category.alias_name!='women closing'
		order BY category.alias_name asc

 !!! Особенность inner join  попадают только пересеченные значения таблиц, не все !!!!



15)  join-ы    "15 join.png"

    inner join - попадают только пересечения таблиц A и B;
    left join - попадает все из таблицы A и пересечения из таблицы B (выводится сперва пересечение, после остатки из таблицы A),
                Недостающие значения заполняются null-ом;
	right join - аналогично как left join, попадат все из таблицы B, и пересечения с таблице A  (выводится сперва пересечение, после остатки из таблицы B),
                Недостающие значения заполняются null-ом;


			SELECT * FROM category;
			SELECT * FROM product;
			SELECT * FROM category INNER JOIN product ON product.category_id = category.id;     -- попадают только пересечения таблиц.
			SELECT * FROM category LEFT JOIN product ON product.category_id = category.id       -- Все что слева от LEFT должно попасть в выборку, ну и пересечение таблиц.
                    WHERE product.id IS null;     -- определим непересекющиеся значения
			SELECT * FROM product RIGHT JOIN category ON product.category_id = category.id;     -- Все что справа от RIGHT JOIN должно попасть в выборку, ну и пересечение таблиц.

	!!! Объединять можно сколько угодно таблиц. - то есть к получившейся склеенной таблице при помощи join-ов можно приклеивать новые таблицы.


	 Можно создавать сложные запросы с подзапросами:
	 - Вывод инфо о товаре , которые не попали ни в один заказ!

		 SELECT * FROM (
			SELECT  product.brand_id, product.price,
                    (`product`.price * `order_products`.count) AS final_price                      -- можно перемножить например столбцы
            FROM `order`
			INNER JOIN `order_products` ON `order`.id = `order_products`.order_id
			right JOIN `product` ON `product`.id = `order_products`.product_id
			WHERE `order_products`.product_id IS NULL
		) AS result                                                                                 -- псевдоним выборки
		INNER JOIN  brand on result.brand_id = brand.id;




16) оператор union
    FULL OUTER JOIN -  получаем все значения как таблицы А так и таблицы B.

    В других языках это выгдядело бы так:
    SELECT * FROM `order`
		FULL OUTER JOIN order_products ON 	order_products.order_id=`order`.ID
		FULL OUTER JOIN product ON order_products.product_id = product.id

    !!!! Но в mysql нет оператора FULL OUTER JOIN, вместо этого можно склеивать несколько sql-запросов при помощи UNION немного костыльным путем.
	UNION - объединение результатов (приклеивает строчки 1-го и 2-го запроса)    "16 union.jpg".



	-- Получаем все заказы
	SELECT * FROM `order`
		left JOIN order_products ON 	order_products.order_id=`order`.ID
		left JOIN product ON order_products.product_id = product.id

	UNION   -- при помощи union склеиваем 2 запроса (количество полей в обоих запросах должно совпадать!)

    -- Получаем все товары
	SELECT * FROM `order`
		inner JOIN order_products ON 	order_products.order_id=`order`.ID
		right JOIN product ON order_products.product_id = product.id;



17) Агрегирубщие ф-ии (собирающее значение для столбца)

	Агрегирующие ф-ии производят вычисления одного "собирающего" значения  (суммы, средного максимального, минимального  значения и т.п.) для заданных групп строк.
		( count , sum, max, min ...)

	 SELECT COUNT(price) AS `COUNT`,
			SUM(price) AS `SUM`,
			MIN(price) AS `min`,
			MAX(price) AS `max`
	FROM product;



18) group by

 - позволяет группировать в одном запросе результаты агрегирубщих ф-ий для нескольких групп строк
    (Например одним запросом получить суммарные суммы заказа для разных пользователей)

		SELECT
		    `order`.user_name,                                                  -- 1-ым пишется тоже самое, что и group by (по чему группируем)
		    SUM(`product`.price*`order_products`.count) AS order_summ           -- 2-м и далее пишутся агрегирующие(собирательные) ф-ии
        FROM `order`
		INNER JOIN
		    `order_products` ON `order`.ID = `order_products`.order_id
		INNER JOIN
		    `product` ON `product`.id = `order_products`.product_id
        --where ...
		GROUP BY `order`.user_name                                             -- группируем по пользователю
	    HAVING order_summ <= 35000;                                            -- можно ставить ограничение на агрегирующие ф-ии при помощи HAVING
                                                                                  !!! при помощи WHERE этого сделать не получится !!!
																				  получить суммарные суммы заказа для разных пользователей И " у которых общая сумма < 35000"



		 Какова общая сумма по каждой категории товаров:
		 SELECT category_id, SUM(price) FROM product GROUP BY category_id;      -- группируем по категориям, собираем по каждой категории общую сумму.





19) Индексы

    SELECT поочередно перебирает все строки.
	Чем больше становится база, тем медленнее она работает.
	!! Не нужно заниматься преждевремменной оптимизацией (когда в базе еще не достаточно информации).
	!! Если мы обнаруживаем медленную работу на каких то запросах, тогда начинаем разбираться.

    Индекс ускоряет процесс запроса, предоставляя быстрый доступ к строкам данных в таблице.

	Не нужно индексировать все столбцы, есть накладные расходы на поддержание индексов (память, обновление индексов),
	поэтому индексация всех столбцов замедлит все ваши операции вставки, обновления и удаления.
	Следует проиндексировать столбцы, на которые вы часто ссылаетесь в предложениях WHERE.




20) Транзакции

		Например:
		Дмитрий переводит Евгению 100 рублей. Пишуться 2 запроса - на списания у Дмитрия на 100 рублей, на зачисление у Евгения на 100 рублей.
		А если выполнился один запрос на списание, и выключилось электричество, то 2-ой запрос не выполнится.
		То есть Дмитрий потеряет деньги, а Евгений их не получит.


		Транзакция - когда выполняется 2 и более операции, и требуется чтобы выполнились две оба гарантированно, либо не выполнилась ни одна из них !
		Оборачиваем в такую конструкцию:

		START TRANSACTION;
			UPDATE user_bank_account SET  money = money-100 WHERE id=1;
			UPDATE user_bank_account SET  money = money+100 WHERE id=2;
		COMMIT;



       Свойства транзакции (ACID):
	     A (atomicity)  - атомарность  (выполняются две оба гарантированно, либо не выполняются ни одна из них)
	     C(consistency) - согласованность  (после окончании транзакции данные должны остаться в согласованном состоянии)
                                          суммарное значение денег в банке (для этих двух пользователей) должно не измениться)
		 I(isolation)   - изолированность  (если транзакция начала выполняться, то уже никто не сможет ей помешать)
                                        даже если в этот момент выполняются другие sql-запросы, затрагивающие эти строки. !
                                        ! сперва выполнится транзакция
		 D(durability)  - долговечность (если по завершении транзакции призошел сбой жесткого диска, отключение питания, после включения питания все изменения транзакции не будут отменены)










