# 10 - Política de protección de claves

## Objetivo

Definir reglas básicas para manejar las claves criptográficas.

## Reglas

1. **Generación:** las claves se generan con un generador aleatorio seguro y con la longitud que recomiende el algoritmo. No se usan palabras ni frases inventadas por una persona.
2. **Almacenamiento:** las claves se guardan en un gestor de secretos o en un servicio de claves, nunca en el código, en scripts SQL ni en el repositorio.
3. **Acceso:** solo pueden usar la clave las personas o aplicaciones que la necesitan, y cada uso queda registrado.
4. **Separación:** la clave no se guarda en el mismo servidor ni en el mismo respaldo que los datos que protege.
5. **Rotación:** las claves se cambian cada cierto tiempo (por ejemplo cada año) y siempre que alguien con acceso deje la organización.
6. **Respaldo:** se hace un respaldo de las claves en un lugar seguro y separado, porque si se pierde la clave se pierden los datos cifrados.
7. **Revocación:** si se sospecha que una clave se filtró, se deja de usar de inmediato y se vuelve a cifrar la información con una clave nueva.
8. **Exposición accidental:** si una clave se sube a un repositorio, se considera comprometida aunque se borre después, porque queda en el historial.
9. **Eliminación:** cuando una clave ya no se usa y los datos ya se volvieron a cifrar, se elimina de forma segura de todos los lugares donde estaba.

## Conclusión

Un buen algoritmo de cifrado no sirve de nada si la clave se maneja mal. La seguridad de los datos cifrados depende de la clave.
