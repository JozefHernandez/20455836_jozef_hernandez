# 02 - Cifrado de información sensible

## Objetivo

Cifrar el RFC de un cliente con `pgp_sym_encrypt()` y recuperarlo con `pgp_sym_decrypt()`.

## Comandos

Script: `sql/02-cifrado-datos.sql`

```sql
INSERT INTO clientes_protegidos (nombre, rfc_cifrado)
VALUES ('Ana López', pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA'));

SELECT * FROM clientes_protegidos;

SELECT id, nombre, pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') AS rfc
FROM clientes_protegidos;
```

## Análisis

**¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()?**
`crypt()` saca un hash que no se puede revertir y se usa para contraseñas. `pgp_sym_encrypt()` cifra el dato con una clave y después se puede descifrar con la misma clave.

**¿Cuál de los dos permite recuperar el dato original?**
`pgp_sym_encrypt()`, usando `pgp_sym_decrypt()` con la clave.

**¿Qué ocurre si se utiliza una clave incorrecta?**
Sale el error `Wrong key or corrupt data` y no se muestra el RFC.

**¿Qué problema de seguridad representa colocar la clave directamente en una consulta?**
Que la clave queda escrita en el script y cualquiera que lo vea la puede usar para descifrar los datos. También puede quedar en el historial de consultas, en logs o en un repositorio.

## Conclusión

El cifrado sirve para datos que sí se necesitan recuperar, como el RFC. Pero la seguridad depende de que la clave esté bien guardada.
