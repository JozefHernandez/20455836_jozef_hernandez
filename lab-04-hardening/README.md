# LAB-04 Hardening y configuración segura de PostgreSQL

## Objetivo

Revisar la configuración de PostgreSQL, ver qué está expuesto de más y dejarlo con lo mínimo necesario, documentando cómo estaba antes y cómo quedó

## Entorno

PostgreSQL 18 instalado en mi computadora

## Superficie de ataque inicial

| Elemento | Estado actual | ¿Es necesario? | Riesgo |
|---|---|---|---|
| Puerto PostgreSQL | 5432 | Sí | Bajo si solo escucha en local |
| Interfaces de escucha | '*' | No, solo me conecto desde la compu | Acepta conexiones por cualquier interfaz |
| Conexiones remotas | No hay, solo la mía desde localhost | No | Ninguno ahorita |
| Usuarios administrativos | postgres | Sí, pero solo para administrar | Se usaba para todo |
| SSL/TLS | off | No en local, sí si se abre a la red | Las conexiones remotas viajarían sin cifrar |
| Métodos de autenticación | scram-sha-256 | Sí | Bajo |

**¿Por qué conocer la superficie de ataque debe preceder al hardening?**

Porque no puedes proteger algo que no sabes que está expuesto, primero se ve qué hay y después se decide qué se quita y qué se protege

## Hallazgos

Archivos de configuración

config_file: postgresql.conf, ahí están parámetros como listen_addresses y el puerto
hba_file: pg_hba.conf, ahí están las reglas de quién se puede conectar
ident_file: pg_ident.conf, para mapear usuarios del sistema con usuarios de PostgreSQL
data_directory: donde están los datos
log_directory: donde se guardan los logs, log_connections y log_disconnections estaban en off

**¿Por qué es importante conocer la ubicación física de estos archivos?**

Porque si alguien los puede leer o cambiar se brinca la seguridad de PostgreSQL, y para revisar sus permisos o hacer cambios primero hay que saber en dónde están

listen_addresses

Configuración encontrada:
'*'

Interfaces necesarias:
localhost

Interfaces innecesarias:
Las demás interfaces de red de la compu

La arquitectura con la red privada reduce más la exposición, porque el servidor no queda directo detrás del firewall hacia internet, solo se llega desde la red privada y desde internet no hay camino

pg_hba.conf

Las reglas que hay son para 127.0.0.1/32 y ::1/128 con scram-sha-256, para todas las bases y todos los usuarios, más las de replicación. No hay reglas con 0.0.0.0/0 ni ::/0. El análisis de la regla permisiva y la regla propuesta están en `configuracion/cambios.md`

Autenticación

password_encryption salió en scram-sha-256

Autenticación es comprobar quién eres y autorización es qué puedes hacer ya que entraste
scram-sha-256 protege la contraseña, porque no viaja tal cual y en la base se guarda un hash con sal
El hash de la contraseña no es cifrado reversible porque no se puede sacar la contraseña original, solo sirve para comprobarla
Si una cuenta tiene permisos de más, aunque su contraseña sea fuerte, si alguien la consigue o la aplicación se compromete puede hacer todo lo que esa cuenta tiene permitido

Roles

| Rol | LOGIN | SUPERUSER | CREATEROLE | CREATEDB | Función |
|---|---|---|---|---|---|
| postgres | Sí | Sí | Sí | Sí | Administrador |
| analista | No | No | No | No | Rol del lab 3 para analítica |
| pg_* | No | No | No | No | Roles que trae PostgreSQL por defecto |

**¿Por qué no debería utilizarse una cuenta SUPERUSER como cuenta normal de una aplicación?**

Porque si alguien hace una inyección SQL o se roba la credencial de la aplicación puede hacer de todo, hasta borrar bases o crear usuarios

Separación de cuentas

| Cuenta | Propósito | LOGIN | Privilegios |
|---|---|---|---|
| DBA | Administración | Sí | Administrativos |
| APP | Aplicación | Sí | Mínimos |
| CONSULTA | Consulta | Sí | Solo lectura |

**¿Qué riesgo existe si la aplicación se conecta utilizando una cuenta administrativa?**

Que cualquier falla de la aplicación se vuelve un problema de toda la base, porque el atacante tendría permisos de administrador

Extensiones

Hay plpgsql, que viene por defecto, y pgcrypto, que se instaló para el lab 2. Las dos se ocupan aquí, pero en otro entorno pgcrypto no debería estar si no se usa

Conexiones

max_connections: 100, cuántas conexiones se aceptan al mismo tiempo
superuser_reserved_connections: 3, conexiones guardadas para el superusuario por si se llena
statement_timeout: 0, tiempo máximo de una consulta, en 0 no tiene límite
idle_in_transaction_session_timeout: 0, tiempo que puede quedarse una transacción abierta sin hacer nada, en 0 no tiene límite

**¿Por qué mantener conexiones indefinidamente abiertas puede representar un problema de disponibilidad o consumo de recursos?**

Porque cada conexión gasta memoria y ocupa un lugar, si se quedan abiertas se llena max_connections y ya nadie más se puede conectar, como pasó en el servidor de la escuela

Permisos del sistema operativo

Se revisaron los permisos de postgresql.conf, pg_hba.conf y de la carpeta data. Lo correcto es que el propietario sea la cuenta del servicio de PostgreSQL y que otros usuarios no puedan leerlos

**¿Por qué no es suficiente proteger PostgreSQL mediante GRANT y REVOKE si cualquier usuario del sistema operativo puede leer archivos sensibles?**

Porque los GRANT solo funcionan dentro de PostgreSQL, si alguien lee los archivos de datos o cambia pg_hba.conf directo en el disco ni pasa por los permisos

Exposición de red

Dirección de escucha:
127.0.0.1

Puerto:
5432

**¿Está expuesto fuera de la interfaz necesaria?**

No, después del cambio solo escucha en localhost

Firewall

| Origen | Destino | Puerto | Acción |
|---|---|---|---|
| 10.10.10.0/24 | PostgreSQL | 5432 | Permitir |
| Cualquier otro origen | PostgreSQL | 5432 | Denegar |

¿Por qué pg_hba.conf y el firewall no son controles equivalentes?
El firewall bloquea antes de que la conexión llegue a PostgreSQL y pg_hba.conf decide ya adentro quién se puede autenticar, a qué base y con qué método. Si falla uno el otro sigue protegiendo

TLS

¿La conexión actual utiliza TLS?
No

Versión:
Ninguna

Cipher:
Ninguno

ssl está en off porque en una instalación local no viene configurado. En local no pasa nada porque no sale a la red, pero si el servidor se abre a otras compus tiene que tener TLS con certificado y los clientes conectarse con verify-full

## Cambios realizados

listen_addresses de '*' a 'localhost' en postgresql.conf y se reinició el servicio
Reglas de pg_hba.conf revisadas y documentadas
Separación de cuentas DBA, APP y CONSULTA
Revisión de permisos de archivos y carpeta data

La tabla de antes y después está en `configuracion/cambios.md` y la línea base en `configuracion/baseline.md`

## Justificación de los cambios

El cambio más importante fue listen_addresses porque con eso PostgreSQL ya no acepta conexiones desde la red, solo desde la misma compu. Lo demás es para que cada cuenta tenga solo lo que ocupa y para que quede documentado

## Verificación

Con `sql/04-verificacion.sql` se comprobó que listen_addresses quedó en localhost y que las reglas de pg_hba.conf son las esperadas

## Checklist de hardening

| # | Control | Verificado | Evidencia |
|---|---|---|---|
| 1 | Puerto documentado | Sí | SHOW port |
| 2 | Interfaces de escucha justificadas | Sí | SHOW listen_addresses |
| 3 | pg_hba.conf revisado | Sí | pg_hba_file_rules |
| 4 | Redes autorizadas restringidas | Sí | Solo localhost |
| 5 | Autenticación segura | Sí | password_encryption scram-sha-256 |
| 6 | Superusuarios identificados | Sí | pg_roles |
| 7 | Cuentas de aplicación separadas | Sí | Tabla de cuentas |
| 8 | Privilegios mínimos | Sí | Tabla de roles |
| 9 | Extensiones revisadas | Sí | pg_extension |
| 10 | TLS verificado | Sí | pg_stat_ssl |
| 11 | Configuración protegida | Sí | Permisos de postgresql.conf y pg_hba.conf |
| 12 | Directorio de datos protegido | Sí | Permisos de data |
| 13 | Firewall documentado | Sí | Tabla de firewall |
| 14 | Actualizaciones documentadas | Sí | baseline.md |
| 15 | Configuración registrada | Sí | cambios.md |
| 16 | Logs de conexiones | No | log_connections en off |
| 17 | Timeouts de conexión | No | idle_in_transaction_session_timeout en 0 |

## Caso integral

| # | Problema | Riesgo | Control propuesto |
|---|---|---|---|
| 1 | Acepta conexiones desde cualquier IPv4 | Cualquiera puede intentar entrar | Limitar a la red de la aplicación |
| 2 | La aplicación usa un usuario administrativo | Si se compromete la aplicación tienen toda la base | Cuenta de aplicación con privilegios mínimos |
| 3 | Escucha en todas las interfaces | Se expone en redes que no se ocupan | listen_addresses solo en la IP necesaria |
| 4 | El firewall deja el 5432 desde cualquier origen | Ataques de fuerza bruta desde internet | Permitir solo la red de la aplicación |
| 5 | pg_hba.conf con all/all desde 0.0.0.0/0 | Todos los usuarios a todas las bases desde donde sea | Reglas por base, usuario y red |
| 6 | Se confía solo en contraseñas fuertes | Si se filtra una contraseña no hay otra barrera | Defensa en capas |
| 7 | No se sabe qué conexiones remotas se ocupan | No se puede restringir bien | Inventario de conexiones |
| 8 | No se menciona TLS | Las contraseñas y datos pueden viajar sin cifrar | TLS con verify-full |
| 9 | No hay separación de cuentas | Todos usan la misma cuenta y no hay trazabilidad | Cuentas por función |
| 10 | No hay registro de conexiones | No se nota un ataque | log_connections y log_disconnections en on |
| 11 | Configuración sin documentar | Nadie sabe qué se cambió | Línea base y registro de cambios |

**¿Es suficiente tener contraseñas fuertes?**

No, la contraseña solo es la autenticación. Si el servidor está abierto a internet, la red no filtra nada, la aplicación usa una cuenta administrativa y no hay TLS, una sola contraseña filtrada o una inyección SQL da acceso a todo. La seguridad tiene que ir en capas: red, autenticación, autorización, configuración y sistema operativo

## Conclusiones

El hardening no es poner más cosas sino quitar lo que no se ocupa y controlar lo que se queda. Aprendí que la red, pg_hba.conf, los roles y el sistema operativo son capas diferentes y que todas cuentan, y que cada cambio se tiene que documentar para saber cómo estaba y cómo quedó