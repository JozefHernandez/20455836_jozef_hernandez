# Evidencia 03 — Diccionario de datos operativo (Actividad 3)

| Columna | Clasificación (Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
| --- | --- | --- | --- | --- | --- |
| id | Dato interno | Identificar al cliente en el sistema | Llave primaria; generado por el sistema | Sí, trigger `trg_auditoria_clientes` | Unicidad y no nulo |
| nombre | Dato personal (identificador directo) | Identificar al cliente | Acceso restringido por rol | Sí, trigger `trg_auditoria_clientes` | No nulo; sin espacios de más |
| correo | Dato personal | Notificaciones al cliente | Acceso restringido por rol | Sí, trigger `trg_auditoria_clientes` | No nulo; formato de correo; unicidad (sin distinguir mayúsculas) |
| rfc | Dato personal | Facturación | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | Formato RFC |
| telefono | Dato personal | Comunicación y seguimiento | Acceso restringido por rol | Sí, trigger `trg_auditoria_clientes` | Formato: 10 dígitos |
| ciudad | Dato personal (ubicación) | Analítica agregada y logística | Acceso por rol | Sí, trigger `trg_auditoria_clientes` | Valor de catálogo de ciudades (sin variantes de escritura) |
| segmento | Dato de negocio | Analítica y estrategia comercial | Acceso por rol | Sí, trigger `trg_auditoria_clientes` | Valores permitidos (catálogo de segmentos) |

## Preguntas

**1. Ventaja de guardar el significado en `COMMENT`.**
Viaja con el objeto: se consulta con SQL junto a la estructura (`col_description`), se respalda y restaura con la base y es difícil que quede desactualizado respecto de un documento aparte que nadie abre. Un documento externo puede divergir de la realidad sin que nadie lo note.

**2. ¿Quedaron registrados los COMMENT en la bitácora? ¿Con qué nivel?**
Sí. `COMMENT ON` es una sentencia DDL y `log_statement = 'mod'` registra DDL además de las sentencias que modifican datos. Lo verifiqué ejecutando los comentarios en un PostgreSQL 16 de prueba con `mod`: aparecen como `statement: COMMENT ON ...` (con `none` no habría quedado nada). con `SELECT num, linea FROM dba.bitacora WHERE linea ~ 'COMMENT ON' ORDER BY num;`.

**3. ¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?**
La que el motor no puede dar fe de sí mismo o que debe sobrevivir a él: quién aprobó la clasificación y cuándo, finalidad y fundamento legal del tratamiento, historial de versiones del significado, plazos de conservación y las excepciones. También la clasificación de MongoDB, que no tiene `COMMENT`. Si la base se pierde o un administrador la altera, esa información debe seguir existiendo y ser verificable.
