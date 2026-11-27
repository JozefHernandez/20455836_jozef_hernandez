# POL-02 — Respaldo

**Objetivo:** Poder recuperar los datos tras pérdida, daño o alteración.
**Alcance:** Base `comercial` de PostgreSQL (esquemas `public`, `auditoria`, `gobierno`, `dba`), base `comercial` de MongoDB y archivos de configuración del servidor. Producción.
**Regla:** Se respalda diariamente toda la base de producción y los archivos de configuración; los respaldos se conservan en un lugar distinto del servidor. Cada trimestre una persona distinta del DBA verifica, con una restauración de prueba, que el respaldo sirve. La pérdida máxima tolerable de datos (propuesta: 24 horas) la fija el propietario.
**Responsable:** Decide frecuencia y tolerancia: propietario del dato. Ejecuta: DBA. Verifica: Auditoría interna o revisor designado.
**Excepciones:** Un respaldo omitido se justifica por escrito y lo autoriza el propietario; no puede repetirse dos días seguidos.
**Evidencia:** **Hoy no existe** registro de respaldos ni de pruebas de restauración en los LAB-01 a LAB-03; se generará en la Unidad V. Una bitácora exportada con hash (E5) **no** sustituye al respaldo.
**Revisión:** Cada año o ante un cambio de tamaño/criticidad de los datos.
