# 01 - Protección de credenciales

## Objetivo

Ver por qué no se deben guardar contraseñas en texto claro y guardarlas con un hash usando `crypt()` y `gen_salt()`.

## Comandos

Script: `sql/01-credenciales.sql`

```sql
SELECT * FROM usuarios_insegura;

SELECT crypt('Password123', gen_salt('bf'));

SELECT usuario,
       password_hash = crypt('Password123', password_hash) AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';
```

**Verificación:**

- Con `Password123`: <!-- t / f -->
- Con `OtraPassword`: <!-- t / f -->

## Análisis

**¿Qué ocurriría si una persona obtiene acceso de lectura a la tabla insegura?**
Vería las contraseñas tal cual y podría entrar con la cuenta de cualquier usuario. Además mucha gente usa la misma contraseña en varios lados, entonces también podría usarla en otras páginas.

**¿Son iguales los dos hash?**
No, salen diferentes aunque la contraseña sea la misma.

**¿Por qué no son iguales?**
Porque `gen_salt()` genera una sal aleatoria diferente cada vez y esa sal se mezcla con la contraseña antes de sacar el hash.

**¿Qué función cumple gen_salt()?**
Genera la sal aleatoria. Con `'bf'` se indica que se use el algoritmo bcrypt (Blowfish).

**¿Qué función cumple crypt()?**
Saca el hash de la contraseña usando la sal. Cuando se le pasa el hash guardado en lugar de una sal nueva, usa la misma sal y sirve para comprobar si la contraseña es correcta.

**¿Esto es cifrado reversible?**
No. Del hash no se puede sacar la contraseña original.

**¿Qué resultado obtuviste con la contraseña correcta y con la incorrecta?**
Con la correcta salió `true` y con la incorrecta `false`.

**¿Por qué no es necesario recuperar la contraseña original?**
Porque para comprobarla solo se saca el hash de lo que escribe el usuario y se compara con el hash guardado. Si coinciden, la contraseña es correcta.

**¿Por qué un hash no debe confundirse con cifrado?**
Porque el cifrado se puede revertir con la clave y el hash no. El hash es de un solo sentido.

## Conclusión

Las contraseñas nunca se deben guardar en texto claro, lo correcto es guardar un hash con sal, así aunque alguien vea la tabla no puede saber cuál es la contraseña.
