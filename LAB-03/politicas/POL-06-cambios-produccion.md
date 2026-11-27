# POL-06 — Cambios en producción

**Objetivo:** Que todo cambio en producción esté autorizado, ejecutado en su ventana y comprobable.
**Alcance:** Cambios de estructura, privilegios, configuración y de datos masivos en el ambiente de **producción**. Ambiente, según la definición de la Unidad I: *[⚠ pega aquí la definición textual de tu Unidad I]*; los valores válidos en `gobierno.solicitudes_cambio.ambiente` son desarrollo, pruebas y producción.
**Regla:** Antes: existe un folio en `gobierno.solicitudes_cambio` aprobado por el Comité de cambios, con ventana de ejecución. Durante: el DBA ejecuta solo dentro de la ventana y no desactiva la auditoría; si hacerlo es indispensable, debe estar en el folio, ser restablecida y verificada en E3 al terminar. Después: una persona distinta del DBA concilia cada mes la bitácora (`CREATE/ALTER/DROP/GRANT/REVOKE`) con los folios.
**Responsable:** Aprueba: Comité de cambios. Ejecuta: DBA. Concilia: Auditoría interna u otra persona distinta.
**Excepciones:** Cambio de emergencia, autorizado por el Comité o su suplente, con folio en 24 horas y conciliación prioritaria.
**Evidencia:** `gobierno.solicitudes_cambio` (p. ej. CAM-2026-014); 06-conciliacion.md; líneas de la bitácora; E3. **Hoy no existe** acta firmada de la revisión mensual.
**Revisión:** Cada 6 meses.
