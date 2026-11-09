# Evidencias de configuración de logging

## 1. ¿Por qué `logging_collector` requiere reinicio y `log_statement` solo recarga?
La diferencia está en el contexto de cada parámetro logging_collector tiene contexto postmaster que significa que solo se lee al arrancar el servidor log_statement en cambio tiene contexto superuser y puede modificarse en breve.

## 2. ¿Qué ventaja tiene leer la bitácora con SQL y qué riesgo introduce?
La principal ventaja es la capacidad de análisis con SQL es posible filtrar por usuario, hora, dirección IP o aplicación, agrupar los intentos fallidos por origen y cruzar la información con la tabla `auditoria_clientes` mediante un `JOIN`. Existe además una dependencia del servicio si PostgreSQL está caído, saturado o comprometido, la bitácora no puede consultarse, mientras que un archivo en disco sí seguiría disponible.

## 3. ¿Quién debería poder consultar `dba.bitacora`?
Solo el personal de administración y auditoría, con permiso de lectura y nunca de escritura. El propietario del objeto sería `postgres`, que administra la tabla pero no debería usarse para el trabajo diario.