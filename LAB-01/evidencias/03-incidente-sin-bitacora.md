# Sin bitacora

## 1. ¿Puedes demostrar quién modificó el RFC?
No Se sabe que el RFC cambió porque facturación lo reportó, pero el servidor no conserva quién lo hizo

## 2. ¿Puedes demostrar que el cambio no lo hizo `soporte_ana`?
Ana solo tiene `SELECT` y por eso no pudo eso describe lo que debería ocurrir según los permisos no lo que ocurrió.

## 3. Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?
No lo impidieron y no debían impedirlo.
No lo impidieron porque `app_ventas` tiene `SELECT` y `UPDATE` sobre `clientes`, de modo que el `UPDATE` era una operación legítima según el diseño. Los privilegios funcionaron correctamente: habrían negado el cambio a `soporte_ana`, que solo tiene `SELECT`, pero permiten el de `app_ventas`. Y no debían impedirlo porque modificar el RFC es una función normal de la aplicación de ventas; bloquearlo rompería la operación del negocio.

## 4. ¿Qué tendría que haber estado configurado antes del incidente?
ALTER SYSTEM SET log_connections    = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix    = '%m [%p] user=%u db=%d app=%a host=%h ';
ALTER SYSTEM SET log_statement      = 'mod';
SELECT pg_reload_conf();