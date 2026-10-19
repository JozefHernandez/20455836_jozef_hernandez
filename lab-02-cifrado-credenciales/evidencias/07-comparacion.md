# 07 - Protección en reposo y en tránsito

## Objetivo

Relacionar cada situación con el mecanismo de protección que le corresponde.

## Resultado

| Situación | Mecanismo apropiado | ¿Qué protege? |
|---|---|---|
| Contraseña de usuario | Hash con sal (bcrypt, Argon2id) | Que no se pueda saber la contraseña aunque se vea la tabla |
| RFC almacenado en una tabla | Cifrado (por ejemplo `pgp_sym_encrypt`) | El dato guardado (en reposo) |
| Consulta enviada desde un cliente al servidor | TLS | Los datos mientras viajan por la red (en tránsito) |
| Respaldo de una base de datos | Cifrado del respaldo | Los datos guardados en el archivo de respaldo (en reposo) |
| Clave criptográfica | Gestión de claves (gestor de secretos, permisos, rotación) | La clave que permite descifrar los datos |

## Análisis

Las contraseñas usan hash porque no se necesitan recuperar, solo comprobar. El RFC y los respaldos usan cifrado porque sí se necesita recuperar la información. TLS protege la comunicación, no lo que está guardado.

## Conclusión

Cada problema necesita su propio mecanismo, y ninguno sirve para todo.
