# POL-04 — Restauración

**Objetivo:** Que una restauración no cause pérdida de datos ni destruya evidencia.
**Alcance:** Restauraciones de la base `comercial` (PostgreSQL y MongoDB), parciales o totales.
**Regla:** Toda restauración en producción requiere una solicitud con folio autorizada por el propietario del dato y aprobada por el Comité de cambios. Se restaura primero en pruebas y se verifica la integridad; antes de restaurar se exportan y se les calcula el hash a las bitácoras vigentes.
**Responsable:** Autoriza: propietario del dato y Comité de cambios. Ejecuta: DBA. Verifica el resultado: persona distinta del DBA.
**Excepciones:** Incidente grave que detenga la operación: la autoriza el propietario o su suplente de forma verbal, con folio en un plazo de 24 horas.
**Evidencia:** Folio en `gobierno.solicitudes_cambio`; línea de bitácora de la restauración. **Hoy no existe** un registro específico de restauraciones.
**Revisión:** Anual o tras cada restauración real.
