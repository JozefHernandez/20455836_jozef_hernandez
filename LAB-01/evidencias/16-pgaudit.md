# Auditoría de objeto sobre columnas sensibles

**1. ¿Por qué no apareció `SELECT nombre, ciudad ...`? ¿Por qué sí apareció `SELECT * ...`?**
En modo objeto pgaudit registra una operación solo si el rol de pgaudit.role tiene privilegios sobre las columnas que la sentencia toca. auditor_datos solo tiene SELECT sobre rfc y telefono. La consulta SELECT nombre, ciudad lee únicamente columnas fuera de ese filtro, así que no se registra. SELECT * lee todas las columnas, incluidas rfc y telefono, por lo que sí cumple el filtro y queda registrada.

**2. ¿Por qué no apareció `UPDATE ... ciudad ...`?**
Porque auditor_datos tiene UPDATE solo sobre rfc y telefono. Esa sentencia modifica únicamente ciudad, que queda fuera del filtro. El UPDATE del rfc sí aparece porque modifica una columna sobre la que el auditor tiene privilegio.

**3. ¿Qué diferencia de volumen esperarías frente a `log_statement = 'all'`?**
Esperaría un volumen mucho menor. log_statement = 'all' registra todas las sentencias sobre todas las tablas, sin distinguir si tocan datos sensibles.

**4. El README oficial advierte que `pgaudit` no puede auditar de forma confiable a los superusuarios. ¿Qué implica para la separación de funciones?**
Un superusuario puede cambiar o desactivar la propia configuración de auditoría y sus privilegios no se limitan con el filtro del rol auditor. Es el mismo límite observado en la Actividad 14 con el disparador. Para la separación de funciones implica que:

- Quien opera la base de datos no debe ser quien controla y custodia la evidencia. Un DBA con privilegios de superusuario no puede ser su propio auditor.
- Debe reducirse el uso cotidiano de cuentas superusuario y usarse roles con privilegios mínimos.
- Las bitácoras de `pgaudit` deben enviarse a un sistema externo administrado por otra área.
- Conviene generar alertas ante cambios en los parámetros `pgaudit.*` y `log_*`.