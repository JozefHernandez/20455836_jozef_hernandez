# Actividad 3

**1. ¿Puedes saber cuál era el RFC antes del cambio con la información de `system.profile`?**
No el documento de update registra el comando (q: { _id: 3 } y u: { $set: { rfc: 'GAMA780912XYZ' } }) es decir, el valor nuevo, pero no el anterior

**2. ¿Puedes saber qué datos tenía el documento eliminado?**
No el documento de remove solo conserva el filtro (q: { _id: 2 }) y el contador (ndeleted: 1). Prueba que se eliminó un documento con _id: 2, quién lo hizo, cuándo y desde dónde, pero no su contenido: nombre, correo, teléfono, RFC y demás campos desaparecieron sin dejar copia.

**3. A diferencia de `log_statement = 'mod'` en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**
Ventaja: Se obtiene evidencia de las lecturas que en PostgreSQL quedaban sin rastro con mod y permite saber quién consultó qué y cuándo. 

Riesgo: El comando se guarda con sus valores literales filtros, valores nuevos y proyecciones.

**4. ¿Por qué el campo `user` incluye `@comercial`?**
Porque en MongoDB la identidad de un usuario es el nombre + base de datos de autenticación no solo el nombre.