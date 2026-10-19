-- configuracion de tls del servidor
SHOW ssl;

SHOW ssl_min_protocol_version;

SHOW port;

SHOW listen_addresses;

-- conexion actual
SELECT
    inet_client_addr(),
    inet_client_port();

-- ¿la sesion actual usa tls?
SELECT
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();

-- 12. desde la terminal (cambiar los datos por los de tu conexion):
-- psql "host=SERVIDOR port=5432 dbname=TU_BASE user=TU_USUARIO sslmode=require"
-- y despues volver a correr la consulta de pg_stat_ssl
