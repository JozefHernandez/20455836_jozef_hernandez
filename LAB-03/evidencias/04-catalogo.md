# Evidencia 04 — Catálogo mínimo de datos (Actividad 4)

| ID | Conjunto de datos | Motor | Ubicación | Propietario | Custodio | Clasificación | Contiene datos personales | Finalidad | Conservación | Diccionario |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CAT-01 | Clientes | PostgreSQL 16 | u3-postgres / comercial / public.clientes | Gerencia Comercial | DBA | Confidencial | Sí | Operación comercial, facturación y contacto con el cliente | Mientras dure la relación comercial y el plazo legal posterior | diccionario-clientes.csv |
| CAT-02 | Auditoría de clientes | PostgreSQL 16 | u3-postgres / comercial / auditoria.cambios_clientes | Auditoría / Seguridad de la información | DBA | Confidencial | Sí (copia valores antiguos y nuevos de clientes) | Evidencia de cambios sobre clientes | Según política de auditoría (por ejemplo, 5 años) | Pendiente |
| CAT-03 | Registro de cambios | PostgreSQL 16 | u3-postgres / comercial / gobierno.solicitudes_cambio | Comité de cambios | DBA | Interna | No (contiene nombres de solicitantes y aprobadores) | Evidencia de autorización de cambios (POL-06) | Según política de auditoría (por ejemplo, 5 años) | Pendiente |
| CAT-04 | Clientes (tienda) | MongoDB 7 | u3-mongo / comercial / clientes | Gerencia Comercial (por confirmar) | DBA | Confidencial | Sí | Operación de la tienda y contacto con el cliente | Mientras dure la relación comercial y el plazo legal posterior | Pendiente |
| CAT-05 | Perfilado | MongoDB 7 | u3-mongo / comercial / system.profile | TI / Seguridad de la información | DBA | Confidencial | Sí (puede guardar filtros y valores de consultas) | Diagnóstico de rendimiento | Corto: se rota o se borra tras el diagnóstico | No aplica (registro técnico) |

## Preguntas

**1. ¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?**
Porque auditar “qué cambió” implica copiar el dato: `valores_antes`/`valores_despues` replican nombre, RFC, correo, etc.; y `system.profile` guarda la forma y a veces los valores de las consultas. La finalidad (auditoría) no cambia la naturaleza del contenido: son datos personales y heredan la clasificación y las restricciones de CAT-01. Por eso E4 muestra solo metadatos.

**2. ¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre motores?**
Nadie puede decidir cuál es el valor correcto: cada propietario defiende el suyo, no hay fuente de verdad y el DBA no debe arbitrar. Hace falta un propietario único (o un acuerdo escrito de cuál sistema es el de referencia para cada atributo) y una regla de conciliación entre ambos motores.

**3. ¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?**
Filas estimadas, tamaño, ubicación (servidores nuevos o migrados) y la lista de conjuntos de datos (altas/bajas de tablas y colecciones). Los datos técnicos los actualiza el custodio (DBA) a partir del motor; propietario, clasificación y finalidad los actualiza o confirma el propietario del dato en cada revisión.
