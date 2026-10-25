# Actividad 11: Matriz de gobierno de datos

| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
|---|---|---|---|---|---|---|
| nombre | Atención y facturación | Atención al cliente | Atención al cliente, facturación | Permisos por rol | Mientras sea cliente | Eliminar |
| correo | Contacto | Atención al cliente | Atención al cliente | Permisos y enmascaramiento | Mientras sea cliente | Eliminar |
| telefono | Contacto | Atención al cliente | Atención al cliente | Permisos y enmascaramiento | Mientras sea cliente | Eliminar |
| rfc | Facturación | Facturación | Facturación | Cifrado y permisos | Lo que diga la ley fiscal | Eliminar |
| edad | Estadísticas | Analítica | Analítica en rangos | Vista con rangos | Mientras sea cliente | Anonimizar |
| ciudad | Estadísticas | Analítica | Analítica agregada | Vista agregada | Mientras sea cliente | Anonimizar |
| codigo_postal | Facturación y estadísticas | Facturación | Facturación, analítica solo por región | Permisos y generalizar | Mientras sea cliente | Anonimizar |
