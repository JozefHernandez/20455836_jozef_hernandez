# Privilegios y estructura

## 1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?
El REVOKE UPDATE ON clientes FROM soporte_ana es un evento de privilegio, no cambia la tabla ni sus datos, solo modifica quién puede hacer qué sobre ella.
El GRANT UPDATE ON clientes TO app_ventas también es un evento de privilegio, en este caso sí amplía lo que una cuenta puede hacer, por lo que es el tipo de cambio que más interesa a un auditor: concede capacidad de modificar datos a una cuenta de aplicación.
El ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20) es un evento de estructura, cambia la definición de la tabla, no los permisos ni las filas existentes

## 2. ¿Por qué `GRANT` y `REVOKE` quedan registrados con `log_statement = 'ddl'`?
Porque PostgreSQL clasifica como DDL (lenguaje de definición de datos) no solo las sentencias que crean o modifican objetos, como `CREATE`, `ALTER` y `DROP`, sino también las que gobiernan el control de acceso sobre ellos.

## 3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II
La leeria un conjunto muy reducido de personas el personal de auditoría y administración de seguridad, con acceso de solo lectura, y el DBA como propietario del mecanismo, sin permiso de modificar o borrar. Ni las cuentas de aplicación como `app_ventas`, ni el rol de soporte, ni `PUBLIC` deben tener acceso a `dba.bitacora` ni al directorio de logs. La razón es que la bitácora pasa a ser un almacén de secretos involuntario quien la lea obtiene credenciales utilizables, y además con valor de atribución: la contraseña de un rol de aplicación permitiría conectarse como esa cuenta, y lo que se hiciera después quedaría atribuido a ella. Por eso debe tratarse con el mismo nivel de protección que cualquier otro secreto, y no con el de un archivo de diagnóstico.