# 08 - Análisis de escenario

## Objetivo

Analizar los riesgos de una empresa que tiene bien los usuarios y roles, pero guarda datos sin protección.

## Escenario

- Contraseñas en texto claro
- RFC en texto claro
- Conexiones sin validar bien el servidor
- Claves criptográficas en archivos SQL
- Respaldos sin protección

## Análisis

**Pregunta 1. ¿Cuáles son los principales riesgos?**
- Si alguien obtiene la tabla de usuarios, tiene todas las contraseñas.
- El RFC se puede usar para fraudes o suplantación.
- Alguien puede hacerse pasar por el servidor (ataque de intermediario) y leer o cambiar la información.
- Con las claves en los archivos SQL, cualquiera que vea el código puede descifrar los datos.
- Si se roban un respaldo, tienen toda la información sin necesidad de entrar a la base de datos.

**Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?**

| Elemento | Mecanismo |
|---|---|
| Nombre | Control de acceso y, si se necesita, enmascaramiento |
| Correo electrónico | Control de acceso y enmascaramiento |
| Contraseña | Hash con sal (bcrypt o Argon2id) |
| RFC | Cifrado de columna |
| Información financiera | Cifrado de columna y acceso restringido |
| Claves criptográficas | Gestor de secretos, fuera del código |
| Conexiones | TLS con `sslmode=verify-full` |
| Respaldos | Respaldos cifrados |

**Pregunta 3. ¿Cuál de los problemas consideras más crítico y por qué?**
Las contraseñas en texto claro, porque con una sola filtración el atacante puede entrar como cualquier usuario, y como muchas personas repiten contraseñas, el daño puede llegar a otras cuentas fuera de la empresa. Muy cerca están las claves en los archivos SQL, porque anulan el cifrado.

**Pregunta 4. ¿Tener bien configurados los usuarios y permisos elimina estos riesgos?**
No. Los permisos solo controlan quién entra por la base de datos. No protegen los datos si alguien roba un respaldo, si lee el tráfico de la red o si encuentra la clave en el código. Además un usuario con permisos legítimos podría filtrar la información.

## Conclusión

Los permisos son necesarios, pero no son suficientes. Se tienen que combinar con hash, cifrado, TLS y una buena gestión de claves.
