https://www.youtube.com/watch?v=Y03xFWa9yGU&ab_channel=%D0%9A%D1%83%D1%80%D1%81%D1%8B%D0%B4%D0%BB%D1%8F%D0%B8%D0%BD%D0%B6%D0%B5%D0%BD%D0%B5%D1%80%D0%BE%D0%B2%D0%B8%D0%B0%D0%BD%D0%B0%D0%BB%D0%B8%D1%82%D0%B8%D0%BA%D0%BE%D0%B2%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85


1. Оконные функции

        min(f.length)      over(partition by   f.rating)
        max(f.length)      over(partition by   f.rating)
        sum(f.length)      over(partition by   f.rating)
        avg(f.length)      over(partition by   f.rating)
        count(f.length)    over(partition by   f.rating)


    ранжирующие

        row_number()      over(partition by   f.rating)
        rank()            over(partition by   f.rating)
        dense_rank()      over(partition by   f.rating)


    Дополнительно

        ntile(3)                over (order by category_id)                                 - разбить на группы по три
        first_value(f.length)   over(partition by   f.rating     order by f.length)         - первое значение
        last_value(f.length)    over(partition by   f.rating     order by f.length)         - последнее значение





    Рамки окна

        sum(rate) over(order by mod_id rows between 2 preceding and current row)            - 2 до - по текущую
        sum(rate) over(order by mod_id rows between 2 preceding and 3 following)            - 2 до - 3 после
        sum(rate) over(order by mod_id rows between unbounded preceding and current row)    - неограниченно до - по текущую


        !!!!!!!!!!
        /*
                sum(rate) over(order by mod_id range between unbounded preceding and current row) as dd
                    одно и то же, что
                sum(rate) over(order by mod_id) as dd


                !!!!!   Родственные строки = дают одинаковый результат.   !!!!
                Когда сортировка "order by" задана - она считает по родственным строкам как:
                    range between unbounded preceding and current row - по умолчанию


                Чтобы изменить это поведение можно добавить доп сортировку по другому полю (или вместо rows использовать range)
                sum(rate) over(order by mod_id, film_id)

        */





























