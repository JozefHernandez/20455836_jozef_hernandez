# Cambios realizados

## Regla permisiva

host    all    all    0.0.0.0/0    scram-sha-256

Bases de datos que permite: todas
Usuarios que permite: todos
Direcciones de origen: cualquier IPv4
Método de autenticación: scram-sha-256
Por qué es exposición innecesaria: aunque pida contraseña, cualquiera desde cualquier red puede intentar entrar con cualquier usuario a cualquier base
Qué se ocupa para restringirla: qué equipo o red se conecta de verdad, a qué base y con qué usuario

Regla actual:
host    all    all    0.0.0.0/0    scram-sha-256

Problema:
Deja intentar conexiones desde cualquier IPv4, a todas las bases y con todos los usuarios

Origen que realmente necesita acceso:
La red de la aplicación 10.10.10.0/24

Base de datos:
basedatos_app

Usuario:
app_user

Regla propuesta:
host    basedatos_app    app_user    10.10.10.0/24    scram-sha-256

## Antes y después

| Control | Antes | Después | Justificación |
|---|---|---|---|
| listen_addresses | '*' | 'localhost' | En el laboratorio solo me conecto desde la misma compu, no ocupa escuchar en todas las interfaces |
| pg_hba.conf | Reglas para 127.0.0.1/32 y ::1/128 con all/all | Solo las bases y usuarios que se usan, desde localhost | Mientras más específica la regla menos se expone |
| Método de autenticación | scram-sha-256 | scram-sha-256 | Ya estaba bien, md5 es más viejo y más débil |
| Usuarios administrativos | Solo postgres como superusuario y se usaba para todo | postgres solo para administrar | Para lo demás se usan cuentas con menos privilegios |
| Cuentas de aplicación | No había, todo se hacía con postgres | Cuentas separadas para app y consulta | Si la aplicación se compromete no se lleva privilegios de administrador |
| Puerto | 5432 | 5432 | Cambiar el puerto no protege, se deja documentado |
| TLS | off | off en local, documentado como pendiente para conexiones remotas | En local no viaja por la red, pero si se abre a la red tiene que ser con TLS |
| Permisos SO | Sin revisar | Revisados, solo la cuenta del servicio y administradores tienen acceso a data | Si otro usuario de la compu lee los archivos se brinca los GRANT |
| Extensiones | plpgsql y pgcrypto | plpgsql y pgcrypto | pgcrypto se ocupa para el lab 2, no hay otras de más |
| Conexiones | max_connections 100, timeouts en 0 | Se documentó usar idle_in_transaction_session_timeout | Que no se queden conexiones abiertas sin hacer nada |