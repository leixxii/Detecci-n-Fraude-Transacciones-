-- ============================================================
-- PROYECTO: Detección e Identificación de Patrones de Fraude
-- Origen de Datos: Dataset de Kaggle:  https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets
-- ============================================================

-- Consulta 1: Detección de transacciones atípicas mediante Funciones de Ventana
--Se implementa una Expresión de Tabla Común (CTE) con funciones de ventana (SUM OVER, AVG OVER, PERCENT_RANK OVER) para calcular el gasto acumulado por tarjeta, el promedio histórico del cliente y su percentil de gasto. Se aíslan las operaciones ubicadas en el percentil 95 o superior para contrastarlas contra la columna is_fraud.

WITH AnalisisVentana AS (
    SELECT
        f.transaction_id,
        f.client_id,
        f.card_id,
        f.amount,
        f.fecha,
        f.hora,
        t.is_fraud,
        SUM(f.amount) OVER (
            PARTITION BY f.card_id ORDER BY f.fecha, f.hora
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Gasto_Acumulado_Tarjeta,
        AVG(f.amount) OVER (PARTITION BY f.client_id) AS Promedio_Gasto_Cliente,
        PERCENT_RANK() OVER (PARTITION BY f.client_id ORDER BY f.amount ASC) AS Ranking_Percentil_Monto
    FROM transactions_final AS f
    INNER JOIN Train_Fraud_Labels AS t ON f.transaction_id = t.Transaction_ID
    WHERE f.amount > 0
)
SELECT TOP 50
    transaction_id, client_id, card_id, amount, fecha, hora,
    Gasto_Acumulado_Tarjeta,
    ROUND(Promedio_Gasto_Cliente, 2) AS Promedio_Gasto_Cliente,
    ROUND(Ranking_Percentil_Monto * 100, 2) AS Percentil_Monto,
    is_fraud
FROM AnalisisVentana
WHERE Ranking_Percentil_Monto >= 0.95
ORDER BY amount DESC;

--Consulta 2:Análisis matricial cruzado mediante el operador PIVOT
--Se utiliza el operador PIVOT para transformar filas en columnas, cruzando la categoría comercial del establecimiento contra el tipo de tarjeta (Crédito vs. Débito) filtrando solo aquellas operaciones marcadas con is_fraud = 'Yes'. Esto permite identificar qué sectores y plásticos sufren mayor incidencia delictiva. 

SELECT
    Categoria_Comercio,
    ISNULL([Credit], 0) AS Tarjeta_Credito,
    ISNULL([Debit], 0) AS Tarjeta_Debito
FROM (
    SELECT
        c.descripcion AS Categoria_Comercio,
        d.card_type,
        f.transaction_id
    FROM transactions_final AS f
    INNER JOIN cards_data AS d ON f.card_id = d.id
    INNER JOIN mcc_codes AS c ON f.mcc = c.cmm
    INNER JOIN Train_Fraud_Labels AS t ON f.transaction_id = t.Transaction_ID
    WHERE t.is_fraud = 'Yes'
) AS BaseDatos
PIVOT (
    COUNT(transaction_id)
    FOR card_type IN ([Credit], [Debit])
) AS TablaPivote
ORDER BY (ISNULL([Credit], 0) + ISNULL([Debit], 0)) DESC;

--Consulta 3: Agrupación demográfica y geográfica con GROUP BY
--Cruzando la tabla users_data con las transacciones mediante INNER JOIN y GROUP BY, se analiza el impacto del fraude según el género del titular y el estado del comercio. Se calculan el total de siniestros, el importe global defraudado y el monto medio por operación.

SELECT
    u.gender AS Genero_Cliente,
    f.merchant_state AS Estado_Comercio,
    COUNT(f.transaction_id) AS Total_Fraudes,
    SUM(f.amount) AS Monto_Total_Fraudulento,
    ROUND(AVG(f.amount), 2) AS Monto_Promedio_Fraude
FROM transactions_final AS f
INNER JOIN users_data AS u ON f.client_id = u.id
INNER JOIN Train_Fraud_Labels AS t ON f.transaction_id = t.Transaction_ID
WHERE t.is_fraud = 'Yes'
  AND f.merchant_state IS NOT NULL
GROUP BY u.gender, f.merchant_state
ORDER BY Total_Fraudes DESC;

--Consulta 4: Reconstrucción temporal con CROSS APPLY (Últimas 3 transacciones)
--Para examinar el comportamiento previo a un evento fraudulento, se utiliza el operador CROSS APPLY junto con una subconsulta correlacionada acotada (TOP 3). Esto despliega las tres operaciones anteriores realizadas con la misma tarjeta, permitiendo identificar movimientos de prueba o inconsistencias geográficas inmediatas.

SELECT
    t.Transaction_ID,
    f.client_id,
    f.card_id,
    f.amount AS Monto_Fraude,
    f.fecha AS Fecha_Fraude,
    UltimasOperaciones.transaction_id AS ID_Transaccion_Previa,
    UltimasOperaciones.amount AS Monto_Previo,
    UltimasOperaciones.fecha AS Fecha_Previa
FROM Train_Fraud_Labels AS t
INNER JOIN transactions_final AS f ON t.Transaction_ID = f.transaction_id
CROSS APPLY (
    SELECT TOP 3
        sub.transaction_id, sub.amount, sub.fecha, sub.hora
    FROM transactions_final AS sub
    WHERE sub.card_id = f.card_id
      AND (sub.fecha < f.fecha OR (sub.fecha = f.fecha AND sub.hora < f.hora))
    ORDER BY sub.fecha DESC, sub.hora DESC

--Consulta 5: Clientes de alto riesgo con Subconsultas Complejas (EXISTS y HAVING)
--Esta consulta combina dos niveles de subconsultas avanzadas para aislar clientes críticos: una subconsulta correlacionada en el WHERE con EXISTS (que valida transacciones en comercios online) y una subconsulta escalar en el HAVING para filtrar aquellos titulares cuyo importe promedio de fraude supera la media global de toda la base de datos.

    SELECT
    u.id AS Cliente_ID,
    u.gender AS Genero,
    u.current_age AS Edad,
    u.credit_score AS Score_Crediticio,
    COUNT(f.transaction_id) AS Cantidad_Fraudes,
    SUM(f.amount) AS Monto_Total_Perdido,
    ROUND(AVG(f.amount), 2) AS Promedio_Por_Fraude
FROM users_data AS u
INNER JOIN transactions_final AS f ON u.id = f.client_id
INNER JOIN Train_Fraud_Labels AS t ON f.transaction_id = t.Transaction_ID
WHERE t.is_fraud = 'Yes'
  AND EXISTS (
      SELECT 1 FROM transactions_final AS tf_sub
      WHERE tf_sub.client_id = u.id AND tf_sub.pais = 'Online / Unknown'
  )
GROUP BY u.id, u.gender, u.current_age, u.credit_score
HAVING AVG(f.amount) > (
    SELECT AVG(tf_global.amount)
    FROM transactions_final AS tf_global
    INNER JOIN Train_Fraud_Labels AS tl_global ON tf_global.transaction_id = tl_global.Transaction_ID
    WHERE tl_global.is_fraud = 'Yes'
)
ORDER BY Monto_Total_Perdido DESC;

