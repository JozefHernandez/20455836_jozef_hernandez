# Actividad 8: Derecho de cancelacion y ciclo de vida

## ¿Existen otras tablas relacionadas?

El DELETE falla por integridad, o borra en cascada datos que debían conservarse o deja datos huérfanos.

## ¿Existen respaldos?

Frecuencia, retención y ubicación de los backups, el dato sigue en el respaldo y reaparece al restaurar.

## ¿Existen réplicas?

Si réplicas de lectura, ambientes de prueba y copias para desarrollo.

## ¿Existen registros de auditoría?

Logs que contengan nombre, correo, RFC o consultas con esos valores.

## ¿Existen copias utilizadas para analítica?

Si no estaban anonimizados el dato sigue identificando a la persona.

## ¿Existen archivos exportados?

CSV, reportes, adjuntos de correo, equipos locales.

## ¿Existen sistemas externos?

Plataforma de correo, CRM, proveedores.

## Construye un pequeño mapa
clientes
│
├── tablas relacionadas
│   ├── pedidos / ventas / resumen_compras
│   ├── facturas y datos fiscales
│   ├── consentimientos / preferencias de contacto
│   ├── tickets y conversaciones de soporte
│   └── clientes_soporte
│
├── respaldos
│   ├── backups completos e incrementales
│   └── snapshots y archivos de recuperación
│
├── réplicas
│   ├── réplicas de lectura / alta disponibilidad
│   └── ambientes de pruebas o desarrollo con copias de producción
│
├── bitácoras y auditoría
│   ├── logs de acceso y de consultas
│   └── registros de cambios
│
├── analítica
│   ├── vistas y tablas derivadas
│   ├── data warehouse / data lake
│   └── datasets de campañas de marketing
│
├── exportaciones
│   ├── CSV / Excel descargados por usuarios
│   ├── reportes en PDF o correo electrónico
│   └── carpetas compartidas y equipos locales
│
└── sistemas externos
    ├── plataforma de envío de correos o campañas
    ├── CRM, mesa de ayuda, facturación electrónica
    └── proveedores y encargados del tratamiento

## ¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?

Porque la base de datos no guarda el dato en un solo lugar DELETE solo quita la fila de la tabla principal.

## Actividad 9: Derecho de oposicion

**¿Es necesario eliminar inmediatamente todos sus datos de la base?**

La oposición y la cancelación son derechos distintos el cliente no pidió que se borre todo sino que sus datos dejen de usarse para una finalidad concreta eso obliga a detener ese tratamiento, no a eliminar el registro completo.

**Explica:**

**qué información podría necesitar mantenerse**

id,nombre,correo y telefono, rfc,codigo postal, fecha_alta

**qué información podría dejar de utilizarse para determinada finalidad**

El cliente debe quedar excluido de las listas y campañas de promociones.

**qué mecanismos técnicos podrían separar finalidades**

Roles y permisos separados: Marketing solo consulta la vista, nunca clientes.
Lista de exclusión que se verifica antes de cada campaña y se sincroniza con proveedores externos.
Propagación a copias: réplicas, analítica y plataformas de envío deben recibir la exclusión.
Bitácora de la solicitud y de su aplicación, para acreditar el cumplimiento.
Separación física o lógica de datos por finalidad cuando el riesgo lo justifique (por ejemplo, tablas distintas para soporte y para marketing).

**por qué la decisión final no debe ser tomada únicamente por el DBA**

El DBA es quien sabe cómo implementar el bloqueo, pero no quien debe decidir si procede ni qué alcance tiene.