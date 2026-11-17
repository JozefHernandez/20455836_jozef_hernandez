# Actividad 1

**1. ¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?**
MongoDB community a evidencia es que db.adminCommand({ buildInfo: 1 }).modules devuelve un arreglo vacío en la edición enterprise ese arreglo incluiría el elemento "enterprise" de modo que su ausencia indica que el binario no contiene los módulos propios de esa edición.

**2. ¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?**
Se sabe consultando db.serverCmdLineOpts().parsed el destino de la bitácora lo determina la sección systemLog.

**3. ¿Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?**
1. Autenticación: inicios de sesión correctos y fallidos, con usuario, origen y momento.
2. Autorización: operaciones permitidas o rechazadas según los privilegios, incluidas las acciones denegadas por falta de permisos.
3. Administración de usuarios y roles: creación, modificación y eliminación de usuarios, roles y privilegios.
4. Cambios de esquema y de configuración: creación o eliminación de bases, colecciones e índices, y cambios en la configuración del servidor.

**4. ¿que tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?**
Qué preguntas necesita responder y si la auditoría nativa las responde, esta registra operaciones pero no necesariamente el valor anterior de un dato así que podría no contestar por sí sola qué valor tenía un campo antes del cambio.
