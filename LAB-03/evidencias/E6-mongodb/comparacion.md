| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
|---|---|---|---|
| Acceso exitoso | Sí  | Sí  | Documentado |
| Acceso fallido | Sí  | Sí  | Documentado |
| Cambio de privilegios | Sí  | No, con las fotos se ve que cambió pero no quién | Documentado |
| Cambio de estructura | Sí  | Parcial, el nivel 2 guarda comandos pero no lo probé | Documentado |
| Modificación de datos | Sí  | Sí (observado) | Documentado |
| Valor anterior del dato | Sí  | No | No, guarda la operación pero no el valor de antes |
| Lectura de datos sensibles | Parcial, solo con `all` o pgaudit | Sí con nivel 2  | Documentado |
| Cambio de configuración del registro | Sí | Parcial, no dice quién y hay que buscarlo por la conexión | Documentado |