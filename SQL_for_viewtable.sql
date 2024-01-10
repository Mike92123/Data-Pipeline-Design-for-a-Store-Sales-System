#Appendix A: View Table Query 

CREATE VIEW Sale_Detail AS  

select  

  s.sales_id,  

  s.date,  

  Year(s.date) as Sale_Year,  

  MONTHNAME(s.date) as Sale_Month,  

  DAYNAME(s.date) as Sale_Day,  

  s.product_family,  

  s.sales,  

  s.onpromotion,  

  o.oil_price,  

  s.store_nbr,  

  s1.store_type,  

  s1.store_cluster,  

  s1.state,  

  s1.city,  

  s2.holiday_type  

from  

  Sales s  

  left join oil_price o on s.date = o.date  

  left join ( 

    select  

      st.store_nbr,  

      st.store_type,  

      st.store_cluster,  

      c.state,  

      c.city  

    from  

      stores st  

      inner join city c on c.city = st.city 

  ) s1 on s.store_nbr = s1.store_nbr  

  left join ( 

    select  

      sh.store_nbr,  

      he.date,  

      max(he.holiday_type) as holiday_type  

    from  

      holiday_events he  

      inner join store_holiday sh on he.holiday_id = sh.holiday_id  

    group by  

      sh.store_nbr,  

      he.holiday_type,  

      he.date 

  ) s2 on s.store_nbr = s2.store_nbr  

  and s.date = s2.date 