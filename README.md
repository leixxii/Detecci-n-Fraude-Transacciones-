

</div>


# 🛡️ Sistema Integral de Detección e Identificación de Patrones de Fraude Financiero

[![Database](https://img.shields.io/badge/Database-SQL%20Server-blue)](https://www.microsoft.com/sql-server)
[![Language](https://img.shields.io/badge/Language-Python%203.x-green)](https://www.python.org/)
[![Visualization](https://img.shields.io/badge/Visualization-Power%20BI-yellow)](https://powerbi.microsoft.com/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-blueviolet)](https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

## 📌 Descripción del Proyecto
Este proyecto aborda de forma global el análisis, la detección preventiva y la auditoría forense del fraude en transacciones con tarjetas de crédito y débito. 

A partir de un dataset masivo con **2,55 millones de transacciones** proveniente de Kaggle, se ha construido una solución integral en tres capas:
1. **Modelado Relacional e Ingesta de Datos (SQL Server):** Estructuración, limpieza y consultas avanzadas mediante funciones de ventana y agregaciones complejas.
2. **Machine Learning No Supervisado (Python):** Detección temprana de anomalías cinemáticas y comportamentales utilizando el algoritmo *Isolation Forest*.
3. **Cuadro de Mando Ejecutivo (Power BI):** Entorno visual con 6 paneles temáticos para auditoría forense, análisis geográfico y gestión del riesgo en tiempo real.

---

## 🗂️ Estructura del Repositorio

```text
├── sql/
│   ├── scrip_fraude.sql              # Scripts T-SQL para limpieza, ETL y consultas de ventana
│   └── Memoria_Explicativa_SQL.pdf   # Documentación metodológica de la base de datos
│
├── machine_learning/
│   ├── Codigo_machine_learning.py    # Pipeline completo de preprocesamiento, Isolation Forest y pruebas
│   └── Memoria_ML_Fraude.pdf         # Memoria técnica del modelo predictivo
│
├── dashboard/
│   ├── Dashboard_Fraude.pbix         # Archivo ejecutable de Power BI
│   └── Memoria_Dashboard_PBI.pdf     # Documentación técnica de las 6 páginas del informe
│
└── README.md                         # Presentación general del proyecto
