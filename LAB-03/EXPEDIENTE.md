# Expediente de auditoría interna — Base comercial

**Comercializadora Norte S.A. de C.V.** · Unidad III — Auditoría, trazabilidad y gobierno práctico de datos · LAB-03
**Elaborado:** 2026-11-26 Jozef Alejandro Hernandez Aguilar 4-1

## 1. Alcance
Revisé la base comercial en PostgreSQ y en MongoDB el periodo va del 2026-11-17 al 2026-11-27 (UTC), que es lo que cubren las bitácoras que conservo. Todo es un ambiente de laboratorio con datos ficticios.
Queda fuera: respaldos y restauración, la auditoría nativa de MongoDB Enterprise y todo lo que pasó antes de que se activara el registro

## 2. Configuración de auditoría (A3)

| Mecanismo | Qué registra | Evidencia |
|---|---|---|
| Colector de registro de PostgreSQL (`logging_collector`, `log_connections`, `log_disconnections`, `log_line_prefix`) | Conexiones, desconexiones y quién/desde dónde | `evidencias/E1-configuracion-registro.txt` |
| `log_statement = 'mod'` | Sentencias DDL (CREATE/ALTER/DROP/GRANT/REVOKE/COMMENT) y DML de modificación (INSERT/UPDATE/DELETE) | E1; `evidencias/E5-bitacora-postgresql.log` |
| Disparador `trg_auditoria_clientes` → `auditoria.cambios_clientes` | Operación, usuario de sesión, aplicación y valores antes/después sobre `clientes` | `evidencias/E3-disparadores.txt`; muestra en `evidencias/E4-muestra-auditoria.txt` |
| Privilegios vigentes | Qué rol puede qué sobre qué tabla | `evidencias/E2-privilegios.txt` (referencia: `app_ventas` SELECT, UPDATE; `soporte_ana` SELECT) |
| Perfilador de MongoDB (`system.profile`), bitácora de `mongod`, instantáneas de privilegios | Operaciones, eventos del servidor y privilegios | `evidencias/E6-mongodb/` (copiado del LAB-02: `system-profile.json`, `bitacora-mongod.log`, hashes y `09-comparacion.md`) |

## 3. Bitácora interpretada (A3, A5)

| # | Línea (resumida, sin secretos) | Tipo | Quién · cuándo · desde dónde | Prueba | No prueba |
|---|---|---|---|---|---|
| 1 | 42: `GRANT UPDATE ON clientes TO app_ventas` | Cambio de privilegios | `postgres` · 2026-11-18 06:30:06 · socket local (psql) | Que la cuenta `postgres` le dio UPDATE a la aplicación | Quién estaba detrás de la cuenta `postgres` ni si alguien lo autorizó (no hay folio) |
| 2 | 326: `AUDIT: OBJECT,...,READ,SELECT,...,"SELECT nombre, rfc FROM clientes WHERE id = 3"` | Lectura de dato sensible | `app_ventas` · 2026-11-18 06:35:00 · 127.0.0.1, app `app-ventas-web` | Que la cuenta de la aplicación leyó el RFC del cliente 3 (María García) | Qué persona usaba la aplicación, el valor que se leyó (`<not logged>`) ni para qué. El nombre de la app lo pone el propio cliente |
| 3 | 340 y 341: `UPDATE clientes SET rfc = ... WHERE id = 1` | Modificación de datos | `app_ventas` · 2026-11-18 06:35:00 · 127.0.0.1 | Que se cambió el RFC del cliente 1. Con el evento 1 de `E4-muestra-auditoria.txt` también se tiene el valor de antes y después | El motivo del cambio ni si el propietario lo pidió |
| 4 | 945: `ERROR: column "edad" of relation "clientes" does not exist` | Error | `postgres` · 2026-11-27 03:44:41 · socket local | Que hubo un intento de INSERT que falló y no cambió nada | Que alguien quisiera hacer daño. Fue el script de la guía, que no coincide con la tabla |
| 5 | 1088: `ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20)` | Cambio de estructura | `postgres` · 2026-11-27 03:46:37 · socket local | Que el cambio se hizo y, junto con `gobierno.solicitudes_cambio`, que fue dentro de la ventana de CAM-2026-014 | Que la aprobación del comité sea real. El registro lo escribe el mismo DBA |

Cronología del incidente del RFC de María García (id = 3):

| # | Hora (UTC) | Usuario | Cliente | Tipo | Qué ocurrió | Fuente |
|---|---|---|---|---|---|---|
| — | Sin registro | — | — | Datos | Primer cambio del RFC: no hay evidencia, el registro estaba apagado | — |
| 1 | 2026-11-18 06:30:04 | — | — | Configuración | `log_statement` pasa de `none` a `ddl`. Desde aquí hay registro | E5, línea 25 |
| 2 | 2026-11-18 06:30:06 | — | — | Configuración | `log_statement` pasa a `mod` | E5, línea 49 |
| 3 | 2026-11-18 06:35:00 | app_ventas | 127.0.0.1 | Lectura | La aplicación lee el nombre y el RFC del cliente 3. Solo lo detecta pgaudit, ni `mod` ni el disparador registran lecturas | E5, línea 326 |
| 4 | 2026-11-27 03:46:37 | — | — | Revisión | `auditoria.cambios_clientes` no tiene ningún evento del cliente 3 | `E4-muestra-auditoria.txt` |

## 4. Elementos de gobierno (A1, A2)

- **Responsables (A1):** `evidencias/02-responsables.md` — propietario Gerencia Comercial, custodio DBA y usuarios `app_ventas` y `soporte_ana` para `clientes`; los roles de auditoría y seguridad son propuesta a confirmar.
- **Catálogo (A1):** `evidencias/04-catalogo.md` — CAT-01 a CAT-07 (PostgreSQL y MongoDB).
- **Diccionario (A2):** `evidencias/03-diccionario.md` y `evidencias/diccionario-clientes.csv` — 11 columnas con COMMENT, clasificación y finalidad; sensibles: nombre, correo, teléfono, RFC, edad, ciudad y código postal (datos personales). `COMMENT` quedó en la bitácora por `log_statement = 'mod'`.

## 5. Conservación (A3)

Criterio razonado en `evidencias/05-conservacion.md`: 12 meses para accesos, modificaciones de datos y `mongod`; 24 meses para privilegios/estructura e instantáneas; `auditoria.cambios_clientes` 12 meses en línea y minimización de datos personales al vencer. **Ningún plazo es legal:** todos los plazos posteriores a la relación comercial están marcados “Plazo a confirmar con el área jurídica” (H-10).

## 6. Políticas (A4)

| Política | Evidencia que demuestra su cumplimiento | ¿Existe hoy? |
|---|---|---|
| POL-01 Acceso (`politicas/POL-01-acceso.md`) | E2; líneas GRANT/REVOKE; folios | E2 y bitácora: sí. Acta mensual: **no** |
| POL-02 Respaldo | Registro de respaldos y de pruebas de restauración | **No** (Unidad V) |
| POL-03 Retención | 05-conservacion.md; `pg_ls_logdir()`; acta de depuración | Criterio: sí. Acta: **no** |
| POL-04 Restauración | Folio y línea de bitácora | **No** (Unidad V) |
| POL-05 Datos sensibles | E2, E3, E4, E5 | Escrituras: sí. **Lecturas: no** |
| POL-06 Cambios en producción | `gobierno.solicitudes_cambio`; 06-conciliacion.md | Registro: sí. Acta de revisión: **no** |

## 7. Conciliación de cambios (A5)
Detalle en `evidencias/06-conciliacion.md`. De todos los cambios de estructura y privilegios de la bitácora, solo `ADD COLUMN canal_alta` (línea 1088) tiene folio (CAM-2026-014) y se hizo dentro de la ventana. Sin folio quedan: `GRANT UPDATE` a `app_ventas` (línea 42), `ADD COLUMN segmento` (línea 43), `GRANT SELECT` a `soporte_ana` (línea 350) y los cambios de preparación del curso. Lo que pasó antes de la línea 25 no se puede conciliar

## 8. Hallazgos

Ningún hallazgo se corrigió en silencio: todos se registran antes de cualquier remediación.

| ID | Hallazgo | Fuente | Severidad | Impacto | Recomendación | Decisión requerida de |
|---|---|---|---|---|---|---|
| H-01 | Calidad de datos: duplicado (1, 7), RFC incompleto/ausente (7, 8), correo, edad, teléfono y CP inválidos (8), variantes de ciudad | `evidencias/01-calidad.md` | Media | Facturación errónea, duplicidad de clientes, analítica sesgada | Correcciones por el propietario; después restricciones `UNIQUE`/`CHECK` con folio | Gerencia Comercial; Comité de cambios |
| H-02 | Cambios de estructura y privilegios sin folio (líneas 34–37; preparación del LAB-01 en producción) | `evidencias/06-conciliacion.md` | Alta | No se puede demostrar que estaban autorizados | Regularizar con folio retroactivo y aplicar POL-06/POL-01 | Comité de cambios |
| H-03 | Desactivación del disparador de auditoría (163, 169, 171) y posibilidad de que una cuenta de aplicación lo intente | `evidencias/06-conciliacion.md`, LAB-01 Act. 14 | Alta | Cambios en `clientes` sin fila de auditoría en la ventana | Retirar de `app_ventas` privilegios de propietario/estructura; alertar por `DISABLE TRIGGER`; cuenta de administración separada | Gerencia Comercial y Responsable de seguridad |
| H-04 | Contraseña en texto claro en la bitácora (línea 37) | LAB-01; E5 | Alta | Secreto expuesto a cualquiera que lea la bitácora | Rotar la contraseña de `rol_temporal`; redactar exportaciones; restringir lectura | Responsable de seguridad |
| H-05 | Hueco de evidencia: la creación de `dba.bitacora` no quedó registrada (`log_statement = none` entonces) | Sec. 7 | Baja | Un activo de auditoría sin trazabilidad de origen | Declarar el hueco; mantener `log_statement` activo desde el arranque | Responsable de seguridad |
| H-06 | Las lecturas de datos personales no se auditan (sin `pgaudit`) | Sec. 9 | Media | No es posible saber quién consultó el RFC de un cliente | Evaluar `pgaudit` para columnas sensibles | Gerencia Comercial (riesgo) y Responsable de seguridad |
| H-07 | MongoDB Community sin auditoría nativa; `system.profile` de 1 MB que se sobrescribe | LAB-02 | Media | Evidencia de MongoDB incompleta y efímera | Exportación periódica con hash; evaluar auditoría de MongoDB Enterprise (no practicada) | Gerencia Comercial |
| H-08 | La auditoría vive en la misma base y la puede desactivar o alterar el administrador | E3; LAB-01 Act. 14 | Alta | Pérdida de confiabilidad de la evidencia | Exportaciones con hash en almacenamiento separado y revisión por persona independiente | Responsable de seguridad |
| H-09 | E1 solo prueba el estado de hoy, no que la configuración estuviera vigente todo el periodo | E1 | Baja | No se puede demostrar continuidad de los controles | Bitácoras de configuración y exportaciones mensuales | Responsable de seguridad |
| H-10 | Conflicto: conservar la auditoría con datos personales vs. eliminar datos personales al vencer la retención; plazos legales sin confirmar | `evidencias/05-conservacion.md` | Media | Posible incumplimiento de obligaciones de datos personales o de conservación | Minimizar valores personales de la auditoría; confirmar plazos con el área jurídica | Área jurídica; Gerencia Comercial |
| H-11 | Roles (propietario de auditoría, seguridad) sin asignar formalmente | `evidencias/02-responsables.md` | Media | Nadie decide sobre la evidencia | Designar formalmente propietarios | Dirección / Comité de cambios |

## 9. Limitaciones conocidas y riesgos aceptados (A6)

| Limitación | Verificado o documentado | Control compensatorio | Quién acepta el riesgo |
|---|---|---|---|
| MongoDB Community no registra cambios de privilegios | Verificado en el LAB-02 | Instantáneas de privilegios | Auditoría interna |
| MongoDB no guarda el valor anterior del dato | Verificado en el LAB-02 | Ninguno | Gerencia Comercial |
| Auditoría nativa de MongoDB Enterprise/Atlas | Documentado, no practicado | — | Dirección (si se compra la licencia) |
| La desactivación del disparador de la guía no está en mi entorno | Verificado (no aparece en E5) | `E3-disparadores.txt` muestra el estado actual | Auditoría interna |
| `<not logged>`: pgaudit no guarda los parámetros ni el valor leído | Verificado (E5, línea 326) | El disparador guarda los cambios, pero no las lecturas | Auditoría interna |
| El usuario de la bitácora es la cuenta, no la persona (todas las apps usan `app_ventas`) | Verificado | Ninguno en la base, tendría que venir de la aplicación | Gerencia Comercial |
| La tabla no tiene `edad` ni `codigo_postal`, así que no se pudo revisar la edad | Verificado (E5, línea 945) | Revisión de teléfono en su lugar | — |

## 10. Índice de evidencias

| Archivo | Qué contiene |
|---|---|
| `evidencias/E1-configuracion-registro.txt` | Configuración de registro |
| `evidencias/E2-privilegios.txt` | Privilegios vigentes |
| `evidencias/E3-disparadores.txt` | Disparador de auditoría |
| `evidencias/E4-muestra-auditoria.txt` | Últimos eventos de la auditoría (solo metadatos) |
| `evidencias/E5-bitacora-postgresql.log` | Bitácora completa con contraseñas tapadas |
| `evidencias/diccionario-clientes.csv` | Diccionario exportado |
| `evidencias/E6-mongodb/` | Perfilador, bitácora de `mongod` |
