# POL-05 — Uso de datos sensibles

**Objetivo:** Limitar y rastrear el acceso a datos personales (RFC, nombre, correo, teléfono, edad, ubicación) de `clientes`.
**Alcance:** Columnas clasificadas como dato personal en `03-diccionario.md`, `auditoria.cambios_clientes`, bitácoras y exportaciones.
**Regla:** Solo accede a datos personales completos quien tenga justificación aprobada por el propietario; soporte usa la vista enmascarada. Toda modificación queda en `auditoria.cambios_clientes` y en la bitácora (`log_statement = 'mod'`). Las bitácoras y exportaciones se redactan (sin contraseñas ni datos completos) antes de compartirse y el expediente de auditoría no reproduce la tabla de clientes.
**Responsable:** Decide: propietario del dato. Ejecuta: DBA. Revisa: Auditoría interna.
**Excepciones:** Acceso a datos completos por incidente o requerimiento legal, autorizado por el propietario y registrado con folio.
**Evidencia:** E2, E3 y E4; líneas `UPDATE/INSERT/DELETE` de la bitácora; E5 (redactada y con hash). **Hoy no existe** registro de **lecturas** de datos sensibles (no hay `pgaudit`): limitación declarada en el expediente.
**Revisión:** Cada 6 meses.
**Coherencia:** La auditoría y las bitácoras se conservan al menos 12 meses (POL-03) para poder investigar accesos a datos sensibles.
