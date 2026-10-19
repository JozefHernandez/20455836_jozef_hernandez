# 04 - TLS

## Objetivo

Revisar si el servidor PostgreSQL tiene TLS activado y si la conexión actual lo está usando.

## Comandos

Script: `sql/03-verificacion-tls.sql`

```sql
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;

SELECT inet_client_addr(), inet_client_port();

SELECT ssl, version, cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
```

Conexión con psql:

```bash
psql "host=SERVIDOR port=5432 dbname=TU_BASE user=TU_USUARIO sslmode=require"
```

## Resultado obtenido

| Consulta | Resultado |
|---|---|
| `SHOW ssl` | <!-- on / off --> |
| `SHOW ssl_min_protocol_version` | <!-- --> |
| `SHOW port` | <!-- --> |
| `SHOW listen_addresses` | <!-- --> |
| `inet_client_addr()` | <!-- --> |
| `pg_stat_ssl` (ssl, version, cipher) | <!-- --> |

## Análisis

**¿La conexión actual utiliza TLS?**
No, ya que el campo que muestra si se utiliza, muestra un false y en version y chipher aparece null porque no utiliza SSL/TLS.

**¿Qué versión de TLS se está utilizando?**
Ninguna.

**¿Qué algoritmo de cifrado aparece?**
Ninguno, ya que al tratarse de una conexion sin TLS/SSL, la sesion no establece ningun mecanismo de cifrado de red y los datos se transmiten en texto plano.

**¿Qué diferencia existe entre una conexión con TLS y una sin TLS?**
Sin TLS, los datos viajan legibles por la red y alguien que esté viendo el tráfico podría leer las consultas y los resultados, incluso contraseñas. Con TLS la información va cifrada, se puede detectar si alguien la modifica y se puede verificar que el servidor es el correcto.

**Sobre sslmode:**
- `require`: pide TLS, pero no revisa que el servidor sea el correcto.
- `verify-ca`: además revisa que el certificado sea de una autoridad de confianza.
- `verify-full`: además revisa que el nombre del servidor coincida con el certificado. Es el más seguro.

## Conclusión

TLS protege los datos mientras viajan entre el cliente y el servidor. Es diferente al cifrado de columnas, que protege los datos guardados.
