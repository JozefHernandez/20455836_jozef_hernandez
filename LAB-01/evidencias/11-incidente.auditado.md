# Incidente auditado

## 1. Compara tu hipótesis de la Actividad 11 con este resultado
En la simulación la conclusión fue que no se podía demostrar quién modificó el RFC ni descartar a soporte_ana ni conocer el valor anterior, solo existía una hipótesis basada en circunstancias el cambio era compatible con un rol que tuviera UPDATE sobre clientes. Era una deducción a partir del diseño de privilegios no una prueba.

## 2. Escribe la sentencia `UPDATE` que restauraría el valor anterior
UPDATE public.clientes
SET rfc = (
    SELECT valores_antes ->> 'rfc'
    FROM auditoria.cambios_clientes
    WHERE id_evento = 1
)
WHERE id = 3;

## 3. ¿Qué columna conserva más valor para una investigación: `aplicacion` o `ip_cliente`? ¿Cuál puede falsificar el cliente con más facilidad?
ip_cliente tiene mas valor Y la que el cliente puede falsificar con más facilidad es aplicacion
aplicacion toma el valor de application_name que el propio cliente escribe en la cadena de conexión cualquiera con las credenciales puede poner app-ventas-web, reporte-mensual o lo que quiera sin ningún obstáculo.
