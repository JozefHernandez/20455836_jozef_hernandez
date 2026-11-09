# Lecturas sensibles y cambios masivos

## 1. Si `clientes` tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un `UPDATE` sin `WHERE`?
El disparador es de nivel fila de modo que se ejecutaría un millón de veces y la tabla de auditoría recibiría un millón de filas nuevas cada una con la fila completa antes y después en JSONB.

## 2. Propón quién podría autorizar la depuración de `auditoria.cambios_clientes`
Responsable de seguridad de la información: como custodio de la evidencia y autorizador principal verifica que los eventos a depurar estén fuera del plazo de retención y que no haya una investigación abierta.

## 3. ¿Por qué `log_statement = 'all'` puede convertir la bitácora en un nuevo depósito de datos sensibles?
Porque la bitácora escribe el texto completo de cada sentencia y ese texto contiene los valores literales que la aplicación o el usuario incluyen.