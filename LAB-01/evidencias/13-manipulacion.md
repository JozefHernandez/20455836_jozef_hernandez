# Evasión de la auditoría por un administrador

## 1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?
La bitácora del servidor las líneas ALTER TABLE clientes DISABLE TRIGGER y ENABLE TRIGGER dejan constancia de que el mecanismo estuvo apagado, con usuario, origen, PID y hora. Cualquier `UPDATE` o `DELETE` sobre `clientes` ubicado entre ambas líneas en el mismo PID o en el intervalo es un cambio sin auditar, aquí el `UPDATE ... 'GAMA780912GHI'` aparece en la bitácora y no en la tabla.

## 2. ¿Qué control administrativo (no técnico) reduciría este riesgo?
El control más eficaz es la **separación de la operación y la custodia de la evidencia**, respaldada por procedimientos formales:
Custodia independiente de las bitácoras: Que las bitácoras se envíen a un sistema administrado por otra área, de modo que el DBA no pueda alterarlas ni borrarlas.
Gestión de cambios: Todo cambio de estructura, trigger o configuración de auditoría requiere una solicitud, una justificación y una aprobación previa registradas.
Uso restringido de la cuenta `postgres`: Procedimiento que limite cuándo y para qué se usa, con cuentas nominales para cada administrador, de modo que cada acción tenga responsable identificable.
Política de consecuencias y capacitación: Que el personal sepa que apagar o eludir la auditoría es una falta grave y que se vigila.
Revisiones y auditorías internas o externas programadas con muestreo de cambios sobre datos críticos.