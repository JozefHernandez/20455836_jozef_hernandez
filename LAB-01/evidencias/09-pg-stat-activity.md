# Evidencias de pg_stat_activity

## 1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?
La columna pid. Es el identificador del proceso del servidor que atiende la conexión, y es el mismo número que aparece entre corchetes en el prefijo de cada línea de la bitácora.

## 2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?
La bitácora, cuando el reporte termina la sesión desaparece de pg_stat_activity porque esa vista solo muestra lo que existe en este momento. 

## 3. ¿Por qué `client_addr` aparece vacío en la sesión del administrador?
Porque la sesión del administrador se conectó por **socket local**, no por red. Cuando `psql` se ejecuta en el mismo equipo con `-U postgres` y sin indicar un host, utiliza el canal local del sistema en lugar de una conexión TCP/IP.