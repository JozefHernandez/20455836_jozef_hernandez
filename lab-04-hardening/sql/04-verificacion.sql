SHOW ssl;
SHOW ssl_min_protocol_version;

SELECT
    pid,
    usename,
    client_addr,
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();

SHOW listen_addresses;

SELECT
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;