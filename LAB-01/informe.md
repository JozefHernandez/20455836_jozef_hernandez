# Informe

## Preguntas de reflexión

**1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?**
Porque registra los hechos a medida que ocurren y no puede reconstruir lo pasado, solo quedarían los respaldos que sirven para conocer un valor pero no para atribuir la acción.

**2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?**
Con logging_collector = on PostgreSQL controla el destino, el nombre, la rotación y el formato de los archivos y todo se configura con parámetros que pueden consultarse y auditarse como log_directory o log_filename, con el colector apagado el destino depende de quien lanzó el proceso y puede variar o perderse sin que la base de datos lo sepa.

**3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?**
Porque el nivel decide qué se registra y el prefijo decide si lo registrado sirve para atribuir. Con `%t`, un `UPDATE` registrado no diría quién lo hizo, desde dónde ni con qué aplicación.

**4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?**
La sentencia dice qué se ordenó quién y cuándo, pero no qué filas ni qué valores cambiaron ni cuántas. El registro del dato guarda la fila antes y después, y por eso permite revertir.

**5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?**
pg_stat_activity muestra en vivo qué hace cada sesión con su estado la consulta en curso y su duración, y permite intervenir con pg_cancel_backend o pg_terminate_backend. La bitácora conserva lo que ocurrió cuando la sesión ya terminó conexiones, fallos, sentencias y desconexiones con su duración.

**6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?**
Nadie, lo audita lo que queda fuera de su control una copia externa de la bitácora custodiada por otra área con hash y permisos de solo anexar alertas ante cualquier DISABLE TRIGGER o cambio de parámetros log_*.
