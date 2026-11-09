## Diseño de auditoría

# Tabla de campos

| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
|---|---|---|---|
| id_evento | BIGSERIAL | No responde una pregunta de Dirección. Identifica cada evento de forma única y conserva el orden en que ocurrieron. | **No.** Es la llave primaria y la genera la secuencia automáticamente. |
| momento | TIMESTAMPTZ | **2. ¿Cuándo?** Es la fecha y hora exactas del cambio. | **No.** Un evento sin fecha no sirve para reconstruir una cronología. Se llena con now() por defecto. |
| usuario_sesion | TEXT | **1. ¿Quién lo hizo?** Es el rol con el que se autenticó la sesión (session_user), aunque el cambio pase por una función SECURITY DEFINER. | **No.** Siempre hay un rol autenticado, y sin él no se puede atribuir el cambio. |
| usuario_efectivo | TEXT | Apoya la pregunta 1. Es el rol con cuyos privilegios se ejecutó la acción (current_user). Dentro de la función es el propietario (postgres), así que sirve para ver con qué privilegios corrió. | **No.** Siempre existe un rol efectivo, y se llena por defecto. |
| aplicacion | TEXT | **3. ¿Desde qué aplicación?** Es el application_name que declara el cliente. | **Sí.** El cliente puede no declararlo y llegar vacío. Además lo declara el propio cliente, por lo que no es evidencia fuerte de identidad. |
| ip_cliente | INET | **3. ¿Desde qué equipo?** Es la dirección IP de origen de la conexión. | **Sí.** En conexiones locales por socket (por ejemplo, la sesión de postgres) no hay IP y inet_client_addr() devuelve NULL. |
| operacion | TEXT | Indica qué se hizo: INSERT, UPDATE o DELETE. Da contexto a la pregunta 5. | **No.** Todo evento corresponde a una operación, y sin ella no se interpretan los campos antes y después. |
| id_cliente | BIGINT | Indica **a qué registro** afectó el cambio, para localizarlo en clientes o reconstruir su historia. | **Conviene que no sea nulo.** En los tres casos que cubre el disparador siempre hay una fila con id. En el diseño de la guía no lleva NOT NULL para no rechazar eventos si se ampliara la auditoría a operaciones sin fila, como TRUNCATE. |
| valores_antes | JSONB | **5. ¿Qué valor tenía antes?** Guarda el registro completo anterior (to_jsonb(OLD)) y permite restaurarlo. | **Sí.** En un INSERT no existía un registro anterior. |
| valores_despues | JSONB | Muestra con qué valor quedó el dato (to_jsonb(NEW)). Comparado con valores_antes, indica qué campo cambió. | **Sí.** En un DELETE ya no hay valor nuevo. |

## Actividad 10 – Esquema y tabla de auditoría

# 1. ¿Por qué `momento` usa `TIMESTAMPTZ` y no `TIMESTAMP`?
Porque `TIMESTAMPTZ` representa un instante absoluto, y `TIMESTAMP` solo una fecha y hora "de reloj" sin zona.

# 2. ¿Por qué se guarda el registro completo en `JSONB` y no solo la columna que cambió?
El incidente reportó el RFC, pero un UPDATE puede modificar varias columnas a la vez, o la persona que investigue puede necesitar ver otras. Guardar la fila completa permite ver todo el estado antes y después, no solo lo que se sospechaba. Si clientes gana o pierde columnas una tabla de auditoría con columnas fijas dejaría de coincidir y habría que migrarla. El JSON conserva cada fila tal como era, con las columnas que tenía en ese momento. Comparando valores_antes con valores_despues se identifica exactamente qué campos difieren, sin tener que anticipar esos campos.

# 3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?
Implica que la tabla de auditoría es tan sensible como clientes y en cierto sentido más contiene los valores actuales y los históricos incluidos los que ya fueron corregidos o borrados. Aunque se elimine un cliente, su RFC sigue existiendo en la auditoría. Debe clasificarse con el mismo nivel que los datos personales de clientes. Hereda las obligaciones que apliquen a esa clasificación: protección de datos personales, plazos de conservación y deber de poder responder solicitudes de acceso o supresión. Esto crea una tensión que debe resolverse por política: la auditoría exige conservar el historial, y la protección de datos puede exigir no conservar datos más tiempo del necesario. Hace falta definir un periodo de retención y un procedimiento de depuración documentado.