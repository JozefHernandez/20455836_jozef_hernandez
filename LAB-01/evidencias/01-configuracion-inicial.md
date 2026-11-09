# Configuracion inicial

## 1. Con esta configuración, ¿se registra quién se conecta?
No log_connections = off y log_disconnections = off las conexiones exitosas y sus desconexiones no dejan línea en la bitácora. Solo quedarían errores graves

## 2. ¿Se registran las sentencias `UPDATE`?
No log_statement = none implica que ninguna sentencia se registra por sí misma.

## 3. ¿La línea de bitácora incluye el usuario o la dirección IP del cliente?
No log_line_prefix = '%t' solo escribe la fecha y hora

## 4. ¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?
America/Chihuahua esta fijada explícitamente en el archivo de configuración.

Importa porque:el firewall, los logs de la aplicación y el sistema operativo pueden usar zonas distintas. Sin conocer cada una, un evento puede parecer ocurrir horas antes o después de otro, e invertir causa y efecto

## 5. Con `logging_collector = off`, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?
El mecanismo con que se desplegó el servidor