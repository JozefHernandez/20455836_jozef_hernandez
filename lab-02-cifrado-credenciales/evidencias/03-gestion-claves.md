# 03 - Gestión de claves

## Objetivo

Identificar el problema de escribir una clave de cifrado dentro de un script.

## Procedimiento

Se creó el archivo temporal `sql/ejemplo-mala-practica.sql` con esta consulta:

```sql
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA')
FROM clientes_protegidos;
```

Después de analizarlo se borró, porque el laboratorio pide no dejarlo en la entrega.

También se revisaron los archivos antes del commit con:

```bash
grep -RniE 'password|passwd|secret|token|api_key|clave' .
```

## Análisis

**¿Qué ocurriría si esta clave fuera real y el archivo se publicara en un repositorio Git?**
Cualquiera con acceso al repositorio podría descifrar todos los RFC. Aunque después se borre el archivo, la clave sigue en el historial de commits, así que habría que cambiar la clave y volver a cifrar todos los datos.

La clave también se puede filtrar por otros lados, como capturas de pantalla, logs, respaldos o documentación.

## Conclusión

Las claves no se deben escribir en el código ni subir al repositorio. Se tienen que guardar aparte, en un lugar hecho para guardar secretos.
