# Actividad 7

**1. ¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**
Porque los privilegios determinan todo lo que una cuenta puede hacer después, y su modificación es la forma más eficaz de preparar o ampliar un ataque.

**2. ¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**
Una vez al día de forma automática además de una instantánea antes y después de cualquier cambio autorizado de privilegios y otra al detectar un evento sospechoso.

**3. ¿Quién debería poder escribir en `auditoria.instantaneas_privilegios`?**
Solo una cuenta de servicio dedicada que ejecute la tarea programada y tenga permiso únicamente de inserción sobre esa colección

**4. Comunicación a Dirección en tres líneas**
Con la configuración actual podemos detectar que los permisos de una cuenta cambiaron y cuál fue el cambio, pero no podemos demostrar quién lo hizo ni a qué hora exacta solo sabemos que ocurrió entre dos revisiones.