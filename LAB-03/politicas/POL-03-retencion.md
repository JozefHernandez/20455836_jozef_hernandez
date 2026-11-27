# POL-03 — Retención

**Objetivo:** Conservar datos y evidencia solo el tiempo necesario, sin perder evidencia que se necesita para investigar.
**Alcance:** Datos de `clientes` (PostgreSQL y MongoDB) y todas las bitácoras (05-conservacion.md).
**Regla:** Los datos de clientes se conservan mientras dure la relación comercial; el plazo posterior es **“Plazo a confirmar con el área jurídica”** (revisar obligaciones de protección de datos personales y fiscales/contables). Las bitácoras se conservan según 05-conservacion.md (12 meses; 24 meses para privilegios/estructura). Al vencer el plazo, el propietario aprueba la eliminación o anonimización y el DBA la ejecuta; en la auditoría con datos personales se conservan los metadatos y se eliminan los valores personales.
**Responsable:** Decide: propietario del dato; plazos legales: área jurídica. Ejecuta: DBA.
**Excepciones:** Retención legal por incidente o requerimiento de autoridad, autorizada por el área jurídica, hasta que se cierre.
**Evidencia:** 05-conservacion.md; listado de archivos de bitácora (`SELECT * FROM pg_ls_logdir()`); hashes de las exportaciones (E5). **Hoy no existe** acta de depuración.
**Revisión:** Anual, y cuando cambie una obligación normativa.
**Coherencia:** La retención de bitácoras (≥12 meses) no es menor de lo que necesita POL-05 para investigar accesos a datos sensibles (12 meses) ni POL-06 para conciliar cambios (24 meses).
