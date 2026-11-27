# Evidencia 02 — Propietarios, custodios y usuarios (Actividad 2)

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quién aprueba accesos | Quién aprueba correcciones |
|---|---|---|---|---|---|
| `comercial.public.clientes` (PostgreSQL) | Gerencia Comercial | DBA | `app_ventas` (SELECT, UPDATE); `soporte_ana` (SELECT, idealmente vía vista enmascarada) | Gerencia Comercial | Gerencia Comercial (valor del dato); Comité de cambios (cambios de estructura) |
| `auditoria.cambios_clientes` (PostgreSQL) | Auditoría interna (o Responsable de seguridad de la información) | DBA | Auditoría interna; DBA solo para operarlo | Auditoría interna | Nadie corrige registros de auditoría; cualquier cambio estructural pasa por el Comité de cambios |
| Bitácora de PostgreSQL | Responsable de seguridad de la información | DBA | Auditoría interna; DBA | Responsable de seguridad de la información | No aplica (no se corrige; solo se redacta en exportaciones, con registro) |
| `comercial.clientes` (MongoDB) | Gerencia Comercial si la tienda en línea depende de otra área | DBA | Aplicación de la tienda | Propietario del dato | Propietario del dato |
| `comercial.system.profile` (MongoDB) | Responsable de seguridad de la información | DBA | Auditoría interna; DBA | Responsable de seguridad de la información | No aplica |

## Preguntas

**1. ¿Por qué el propietario de `auditoria.cambios_clientes` no debería ser quien opera `clientes`?**
Por separación de funciones: quien puede modificar los datos no debe controlar la evidencia de sus propios cambios. Si el mismo rol opera `clientes` y es dueño de la auditoría, puede alterarla, desactivarla o decidir qué se revisa, y la evidencia pierde valor frente a un auditor. (En el LAB-01 se observó que desactivar el disparador era posible.)

**2. ¿Quién debe leer las bitácoras y `dba.bitacora`? ¿Qué se observó en el LAB-01?**
Solo el DBA (como custodio) y Auditoría interna, por solicitud aprobada. En el LAB-01 la bitácora mostró secretos en texto claro (la contraseña de `CREATE ROLE rol_temporal`, línea 37 de la salida de referencia), y además contiene sentencias con datos personales. Por eso: lectura restringida, exportaciones redactadas y verificadas con hash, y nunca compartir una extracción sin revisarla.

**3. ¿Qué ocurre con la responsabilidad cuando nadie la tiene asignada?**
Nadie decide, nadie corrige y nadie responde. Es el problema inicial de la unidad: ante un cambio indebido (p. ej. el RFC de María García) no hay quien diga si fue correcto, qué regla se incumplió ni a quién escalar. Un dato sin propietario queda a merced de quien tenga acceso técnico, y el DBA termina decidiendo por defecto, lo cual no le corresponde.
