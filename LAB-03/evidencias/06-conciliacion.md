# Evidencia 06 — Conciliación de cambios (Actividad 7)

| Línea | Momento (bitácora) | Usuario | Sentencia | Folio que lo autoriza | ¿Autorizado? | Hallazgo |
|---|---|---|---|---|---|---|
| 34 | 2026-10-25 22:50:09.341 | postgres | `REVOKE UPDATE ON clientes FROM soporte_ana` | Ninguno | No (sin folio) | H-02: preparación del LAB-01; en producción sería cambio de privilegios sin solicitud |
| 35 | 2026-10-25 22:50:09.367 | postgres | `GRANT UPDATE ON clientes TO app_ventas` | Ninguno | No (sin folio) | H-02: ídem. Es el privilegio que figura en E2 (SELECT, UPDATE) |
| 36 | 2026-10-25 22:50:09.372 | postgres | `ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)` | Ninguno | No (sin folio) | H-02: cambio de estructura sin folio (preparación del LAB-01) |
| 37 | 2026-10-25 22:50:09.375 | postgres | `CREATE ROLE rol_temporal LOGIN PASSWORD '<REDACTED>'` | Ninguno | No (sin folio) | H-02 y H-04: alta de rol sin folio y **contraseña en texto claro en la bitácora** |
| 163 | 2026-10-25 22:50:53.460 | app_ventas | `ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes` | Ninguno | **No** | H-03 (Alta): una cuenta de aplicación intentó desactivar la auditoría |
| 169 | 2026-10-25 22:50:53.549 | postgres | `ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes` | Ninguno | **No** | H-03 (Alta): el administrador desactiva la auditoría sin folio |
| 171 | 2026-10-25 22:50:53.554 | postgres | `ALTER TABLE clientes ENABLE TRIGGER trg_auditoria_clientes` | Ninguno | No (restablece el control) | H-03: ventana de ~5 ms entre 169 y 171 en la que cambios sobre `clientes` no habrían quedado en `auditoria.cambios_clientes` |
| 216 | 2026-10-25 22:54:26.533 | postgres | `ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20);` | CAM-2026-014 | Sí | — |


## Preguntas

**1. ¿Qué cambios no tienen folio? ¿Preparación o hallazgos?**
Todos los de la tabla excepto la línea 216. Las líneas 34–37 son de preparación del LAB-01 (se ejecutaron para construir el entorno), pero en un servidor real serían hallazgos porque son cambios de privilegios/estructura sin solicitud; se declaran como hallazgo con la nota “preparación de laboratorio” y no se justifican en silencio. Las líneas 163, 169 y 171 no son preparación del entorno: derivan de la manipulación de la auditoría (LAB-01 Act. 14) y son hallazgos.

**2. Gravedad de desactivar el disparador y diferencia entre 163 y 169.**
Alta es desactivar el control que sustenta la evidencia del dato; mientras está desactivado, cualquier `UPDATE/DELETE` sobre `clientes` pasa sin dejar fila de auditoría, y solo queda la bitácora (por eso se conservan las dos fuentes). La diferencia está en quién lo ejecuta: la línea 163 es de una cuenta de aplicación (`app_ventas`), que no debería poder administrar la tabla; la 169 es del administrador (`postgres`), que sí puede técnicamente pero lo hizo sin folio. Además, `log_statement` registra la sentencia antes de ejecutarla: que aparezca la 163 no prueba que haya tenido éxito. Se confirma buscando una línea `ERROR: must be owner of table clientes` justo después; si existe, fue un intento fallido (igualmente relevante); si no existe, `app_ventas` tenía privilegios de más.

**3. Limitación de la conciliación si `log_statement` estuvo en `none`.**
No hay evidencia de lo ocurrido en ese periodo: un cambio ejecutado entonces no aparece, y la conciliación daría falsa seguridad (“no hay cambios sin folio”). Solo se puede decir “no hay cambios sin folio *en el periodo cubierto por la bitácora*”. Es el caso de la creación de `dba.bitacora`. Además, `ALTER SYSTEM`/cambios en `postgresql.conf` que bajaran el nivel tampoco quedan registrados si se hacen en el momento equivocado.

**4. ¿Quién debe conciliar?**
Una persona distinta a quien ejecutó los cambios (Auditoría interna o un segundo revisor designado por el propietario). Si el DBA se concilia a sí mismo, no hay independencia: puede omitir, reinterpretar o preparar la evidencia. El DBA aporta la extracción; otra persona la compara contra los folios y firma el acta.
