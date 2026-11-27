# POL-01 — Acceso

**Objetivo:** Reducir el riesgo de accesos no autorizados o excesivos a la base comercial.
**Alcance:** Roles y privilegios sobre `comercial` (PostgreSQL) y `comercial` (MongoDB); producción, pruebas y desarrollo. Incluye cuentas de personas y de aplicaciones.
**Regla:** Todo acceso o cambio de privilegios en producción requiere una solicitud con folio aprobada por el propietario del dato (para `clientes`, Gerencia Comercial); el DBA solo otorga el mínimo privilegio solicitado. El DBA revisa mensualmente las líneas `GRANT/REVOKE` de la bitácora y las concilia con los folios; trimestralmente se compara E2 con la matriz de roles y con la tabla de responsables (02-responsables.md).
**Responsable:** Decide: propietario del dato. Ejecuta: DBA. Concilia: Auditoría interna u otra persona distinta del DBA.
**Excepciones:** Acceso de emergencia hasta 24 horas, autorizado por el propietario o su suplente; se registra el folio a más tardar el siguiente día hábil y el acceso se revoca al vencer.
**Evidencia:** Líneas `statement: GRANT/REVOKE` de la bitácora (LAB-01, Act. 6; 06-conciliacion.md); E2 (privilegios vigentes); `gobierno.solicitudes_cambio` (LAB-03). **Hoy no existe** acta de la revisión mensual ni un registro de solicitudes de acceso separado del de cambios.
**Revisión:** Cada 6 meses o tras un incidente de acceso.
