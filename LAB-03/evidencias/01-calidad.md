# Evidencia 01 — Calidad de datos desde la operación (Actividad 1)

## Hallazgos

| # | Hallazgo | Registros | Regla de calidad | ¿Quién decide la corrección? | Acción propuesta |
|---|---|---|---|---|---|
| C1 | Posible cliente duplicado | 1, 7 | Unicidad del correo | Gerencia Comercial | Gerencia Comercial confirma si es la misma persona y decide cuál registro se conserva o se fusiona. Después, con aprobación del Comité de cambios, crear índice único sobre `lower(correo)`. |
| C2 | RFC incompleto: `LOAA850315AB` | 7 | Formato del RFC | Gerencia Comercial | Obtener el RFC completo con el cliente o su constancia fiscal. El DBA no “completa” el valor. |
| C3 | RFC ausente (`NULL`) | 8 | Completitud del RFC (si es obligatorio para facturar) | Gerencia Comercial | Definir si el RFC es obligatorio; si lo es, recabarlo y luego evaluar `NOT NULL`/`CHECK`. |
| C4 | Correo con formato inválido: `sin-correo` | 8 | Formato de correo | Gerencia Comercial | Recabar correo válido o marcar el cliente como “sin correo” según una regla que defina el propietario. |
| C5 | Edad fuera de rango: `-3` | 8 | Rango de edad (18–120, según la regla de negocio que apruebe el propietario) | Gerencia Comercial | Recabar edad o fecha de nacimiento; luego `CHECK (edad IS NULL OR edad BETWEEN 18 AND 120)`. |
| C6 | Teléfono con 3 dígitos: `667` | 8 | Formato de teléfono (10 dígitos) | Gerencia Comercial | Recabar teléfono completo. |
| C7 | Código postal de 4 dígitos: `8000` | 8 | Formato de código postal (5 dígitos) | Gerencia Comercial | Corregir con el cliente; luego `CHECK (codigo_postal ~ '^[0-9]{5}$')`. |
| C8 | Variantes de escritura de ciudad (`Culiacan` / `Culiacán`) | 7 | Consistencia de catálogo | Gerencia Comercial | Definir catálogo de ciudades o regla de normalización. |

## Preguntas

**1. ¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 7?**
Porque no es el propietario del dato. El DBA no sabe cuál es el valor correcto: “completar” la homoclave inventándola o deduciéndola dejaría en la base un RFC que parece válido pero puede ser falso, con consecuencias fiscales (facturación). Además, una corrección sin autorización es un cambio no conciliable: el propietario decide el valor correcto y el DBA lo ejecuta con evidencia de esa decisión.

**2. ¿Qué restricción habría evitado cada hallazgo y quién debe aprobar agregarla?**
El DBA las implementa, pero las aprueba el dueño del dato junto con el responsable de la aplicación, mediante control de cambios, porque son reglas de negocio y pueden afectar al sistema que inserta los datos.

**3. Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) deja evidencia?**
El disparador `trg_auditoria_clientes`, que escribe en `auditoria.cambios_clientes` (operación, usuario de sesión, aplicación, valores antes/después), más la línea `statement: UPDATE ...` de la bitácora por `log_statement = 'mod'`. Limitación: si el disparador estuviera desactivado (hallazgo del LAB-01, Act. 14), solo quedaría la bitácora.
