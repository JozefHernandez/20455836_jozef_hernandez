-- LAB-03 · Actividad 3 — Diccionario de datos operativo dentro del motor

COMMENT ON TABLE clientes IS 'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificación: confidencial (contiene datos personales).';
COMMENT ON COLUMN clientes.id            IS 'Identificador interno del cliente. Generado por el sistema.';
COMMENT ON COLUMN clientes.nombre        IS 'Nombre completo. Dato personal identificador directo.';
COMMENT ON COLUMN clientes.correo        IS 'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';
COMMENT ON COLUMN clientes.rfc           IS 'RFC del cliente. Dato personal. Uso: facturación. Cambios auditados en auditoria.cambios_clientes.';
COMMENT ON COLUMN clientes.edad          IS 'Edad en años cumplidos. Dato personal. Uso: analítica agregada.';
COMMENT ON COLUMN clientes.telefono      IS 'Teléfono de contacto (10 dígitos). Dato personal. Uso: seguimiento de ventas y soporte.';
COMMENT ON COLUMN clientes.ciudad        IS 'Ciudad de residencia o entrega. Dato personal (dato de ubicación). Uso: logística y analítica agregada.';
COMMENT ON COLUMN clientes.codigo_postal IS 'Código postal (5 dígitos). Dato personal (dato de ubicación). Uso: logística y analítica agregada.';
COMMENT ON COLUMN clientes.fecha_alta    IS 'Fecha y hora de alta del cliente. Generada por el sistema. No es dato personal sensible.';
COMMENT ON COLUMN clientes.segmento      IS 'Segmento comercial asignado al cliente. Uso: estrategia comercial. Definido por Gerencia Comercial.';

COMMENT ON TABLE auditoria.cambios_clientes IS 'Auditoría de INSERT/UPDATE/DELETE sobre clientes (disparador trg_auditoria_clientes). Contiene datos personales en valores_antes/valores_despues. Custodio: DBA. Lectura restringida.';
COMMENT ON VIEW  dba.bitacora IS 'Vista de lectura de la bitácora del servidor. Puede contener secretos en texto claro: revisar antes de compartir. Lectura restringida al DBA/auditoría.';

-- Diccionario combinado
SELECT c.ordinal_position          AS pos,
       c.column_name               AS columna,
       c.data_type                 AS tipo,
       c.character_maximum_length  AS longitud,
       c.is_nullable               AS acepta_nulos,
       c.column_default            AS valor_por_defecto,
       col_description('public.clientes'::regclass, c.ordinal_position) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;

-- Comprobación de columnas
SELECT c.column_name
FROM information_schema.columns c
WHERE c.table_schema = 'public' AND c.table_name = 'clientes'
  AND col_description('public.clientes'::regclass, c.ordinal_position) IS NULL;
