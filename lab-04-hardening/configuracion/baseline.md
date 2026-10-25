# Línea base de seguridad PostgreSQL 16

## Red

Interfaces autorizadas: solo localhost o la IP privada que se ocupe, nunca '*' sin justificar
Puerto: 5432 documentado
Firewall: 5432 abierto solo para la red que lo ocupa y lo demás denegado
Redes permitidas: en pg_hba.conf solo redes específicas, nada de 0.0.0.0/0 ni ::/0

## Autenticación

Método: scram-sha-256 y no usar md5 ni trust
Políticas de credenciales: contraseñas largas, una por cuenta y que no estén en el código
Cuentas administrativas: solo postgres o la del DBA, y que no se use para las aplicaciones

## Autorización

Roles: un rol por función, por ejemplo DBA, aplicación y consulta
Privilegios: cada rol con lo mínimo que ocupa
Cuentas de aplicación: sin SUPERUSER, CREATEROLE ni CREATEDB

## Configuración

Parámetros relevantes: listen_addresses, password_encryption, log_connections y log_disconnections en on
Extensiones: solo las que se ocupan
Conexiones: max_connections según lo que se use y timeouts para conexiones inactivas

## Sistema operativo

Propietario de archivos: la cuenta del servicio de PostgreSQL
Permisos: postgresql.conf y pg_hba.conf que no los pueda leer cualquier usuario
Directorio de datos: solo la cuenta del servicio y administradores

## Cifrado

TLS: ssl en on, ssl_min_protocol_version TLSv1.2 y clientes con verify-full si hay conexiones remotas
Protección de credenciales: contraseñas con hash scram-sha-256
Información sensible: cifrar columnas como el RFC y los respaldos

## Mantenimiento

Actualización: aplicar las versiones menores de PostgreSQL 16 cuando salgan
Revisión periódica: revisar pg_hba.conf, roles y extensiones cada cierto tiempo
Documentación: cada cambio se anota con fecha, quién lo hizo y por qué