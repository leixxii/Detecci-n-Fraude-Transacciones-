# 📊 Dashboard Interactivo de Análisis de Fraude y Clientes (Power BI)


<p align="justify">
<b>Dado que el archivo ejecutable de Power BI (.pbix) supera los límites de almacenamiento para archivos pesados en GitHub</b>, la Memoria Técnica en PDF adjunta en esta carpeta incluye las capturas de pantalla de cada uno de los paneles interactivos, acompañadas de su respectivo análisis forense y metodológico. El cuadro de mando fue estructurado en 6 páginas o paneles temáticos, diseñados para guiar al usuario desde una perspectiva macroscópica del negocio hasta el detalle operativo de cada transacción.
</p>

---

### 🖼️ Detalle de las Páginas del Reporte (Visión General y Objetivos)

| Sección | Objetivo Principal | Análisis y Elementos Observables |
| :--- | :--- | :--- |
| **1. Resumen Ejecutivo** *(Visión Macro)* | Centro de control financiero para evaluar el estado operativo global de la cartera. | Métricas globales de transacciones (2,55 M) y volumen operado (110,81 M€). Gráfico combinado de barras y líneas para contrastar la evolución temporal (2010 vs. 2011) y curva horaria que revela el pico crítico de ataques en la madrugada (01:00 AM a 06:00 AM). |
| **2. Control Fraude** *(Análisis Demográfico)* | Diagnosticar el impacto del riesgo a nivel de titular, perfil etario y red de medios de pago. | Aislamiento de 2.617 operaciones fraudulentas, 336 tarjetas y 305 clientes (313.092 € en pérdidas). Gráfico de dispersión para detectar clústeres de *outliers* (hasta 2% de tasa de fraude), desglose por rangos de edad (mayor riesgo en >50 años) y ranking Top 5 de pérdidas. |
| **3. Detalle del Cliente** *(Auditoría Forense)* | Permitir investigaciones individuales mediante análisis de perforación (*drill-down*). | Indicador predictivo de nivel de riesgo (Score 0-100), historial pormenorizado de transacciones de mayor cuantía (*Swipe*/banda magnética) y mapa global que cruza compras físicas vs. *Online* para auditar patrones de "viaje imposible". |
| **4. Riesgo Comercio** *(Análisis Sectorial)* | Evaluar la vulnerabilidad en la red de establecimientos y pasarelas de pago. | Registra un 63,30% de penetración de fraude en la red comercial. Desglosa el impacto por canal (*Online* absorbe el 55,96%), tipos de error en pasarela y reclasificación por macrocategorías (mayor perjuicio económico en sector *Retail* / Minoristas). |
| **5. Impacto Geográfico** *(Análisis Espacial)* | Mapear la dispersión territorial e identificar concentraciones anómalas de riesgo. | Mapa de áreas proporcionales (*Treemap*) que demuestra la dominancia del canal digital (*Online* representa >90% de pérdidas), focos presenciales críticos (*Port-au-Prince, Haití*) y picos de fraude en días específicos del mes. |
| **6. Tarjetas** *(Registro Maestro)* | Servir como registro granular a nivel de fila/transacción para gestionar contracargos. | Matriz pormenorizada con el detalle cronológico de cada una de las 2.617 transacciones ilícitas. Permite identificar micro-cargos de prueba (ej. 0,49 €) y concentraciones atípicas en clubes de venta al por mayor. |
