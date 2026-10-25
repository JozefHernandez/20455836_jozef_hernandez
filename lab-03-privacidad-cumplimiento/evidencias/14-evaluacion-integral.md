# Actividad 14 Escenario integral

| # | Problema | Principio afectado | Riesgo | Control propuesto |
|---|---|---|---|---|
| 1 | Todos los de analítica consultan directo la tabla clientes | Mínimo privilegio | Ven datos que no ocupan | Darles una vista agregada y quitar el permiso a la tabla |
| 2 | Analítica ve nombre, correo, teléfono y RFC | Minimización | Exposición de datos personales | Vista sin datos que identifican |
| 3 | Analítica solo hace estadísticas mensuales pero tiene datos individuales | Finalidad | Usar los datos para otra cosa | Darle solo datos agregados |
| 4 | Los datos se guardan desde hace 12 años | Retención | Más datos expuestos si hay una fuga | Definir plazos y borrar o anonimizar lo vencido |
| 5 | No hay política de retención documentada | Gobierno de datos | Nadie sabe cuándo borrar | Hacer una política de retención con responsables |
| 6 | Los desarrolladores reciben copias completas de la base | Minimización | Datos reales en equipos menos protegidos | Darles datos de prueba o enmascarados |
| 7 | Las copias de desarrollo tienen información real | Ciclo de vida | Fuga desde desarrollo | Anonimizar las copias y borrarlas al terminar |
| 8 | Marketing usa los correos para campañas | Finalidad | Usar datos sin consentimiento | Revisar el aviso de privacidad y pedir consentimiento |
| 9 | No hay documentación de qué finalidad tiene cada dato | Gobierno de datos | No se puede justificar el tratamiento | Hacer un catálogo de datos con finalidad y responsable |
| 10 | No se sabe quién consulta los datos | Trazabilidad | No se puede saber quién filtró algo | Activar auditoría de accesos |
| 11 | El RFC no está protegido | Confidencialidad | Fraude o robo de identidad | Cifrar el RFC y dejarlo solo para facturación |
| 12 | No hay forma clara de atender solicitudes ARCO | Derechos ARCO | No poder responder a tiempo | Procedimiento ARCO y saber en dónde está cada copia |