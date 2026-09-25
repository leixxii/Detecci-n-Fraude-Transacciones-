-- ============================================================
-- PROYECTO: Detección e Identificación de Patrones de Fraude
-- Origen de Datos: Dataset de Kaggle
-- ============================================================

-- Paso 1: Detección de transacciones atípicas mediante Funciones de Ventana
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
