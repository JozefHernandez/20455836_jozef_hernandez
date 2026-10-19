# LAB-02 Cifrado, credenciales y comunicaciones seguras

## 1. Introducción

En el laboratorio anterior se controló quién puede ver los datos. En este se trabajó con lo que pasa cuando eso no es suficiente: contraseñas guardadas en texto claro, datos sensibles sin cifrar, conexiones sin protección y claves escritas dentro del código. Se usó la extensión `pgcrypto` de PostgreSQL y se revisó la configuración de TLS del servidor.

## 2. Protección de credenciales

- **Texto claro:** la contraseña se guarda tal cual y cualquiera que vea la tabla la puede leer.
- **Hash:** se transforma la contraseña en un valor del que no se puede sacar la original. Con `crypt()` y `gen_salt('bf')` se usó bcrypt con sal, por eso la misma contraseña da un hash diferente cada vez. Para comprobarla se vuelve a sacar el hash y se compara.
- **Cifrado:** se puede revertir con una clave. No se usa para contraseñas, porque si alguien consigue la clave puede sacar todas.

## 3. Protección de datos sensibles

Se cifró el RFC con `pgp_sym_encrypt()`, porque es un dato personal que la empresa sí necesita recuperar en algunos casos. En la tabla el RFC queda como datos binarios que no se pueden leer, y solo con la clave correcta se recupera con `pgp_sym_decrypt()`. Con una clave equivocada sale error.

## 4. TLS

TLS protege los datos mientras viajan entre el cliente y el servidor, para que no los puedan leer ni modificar en la red. También permite comprobar que nos estamos conectando al servidor correcto si se usa `sslmode=verify-full`.

Se revisó con `SHOW ssl` y con la vista `pg_stat_ssl` si el servidor tiene TLS activado y si la conexión lo estaba usando.


## 5. Gestión de claves

Las claves no se deben guardar junto con los scripts porque cualquiera con acceso al código las podría usar para descifrar los datos. Si se suben a un repositorio quedan en el historial aunque se borren después. En este laboratorio solo se usó la clave de prueba `CLAVE-DE-PRUEBA`.

## 6. Resultados

- La tabla insegura muestra la contraseña `Password123` tal cual.
- El hash con `crypt()` cambia cada vez por la sal, y la verificación dio `true` con la contraseña correcta y `false` con la incorrecta.
- El RFC cifrado no se puede leer, y se recupera solo con la clave correcta.
- TLS en el servidor: Sin TLS las consultas, los resultados y las contraseñas viajan en texto claro por la red de moco que un atacante puede espiarlos o modificarlos en transito.

## 7. Problemas encontrados

- El servidor de la escuela no dejaba conectarse porque se llenaron las conexiones (`remaining connection slots are reserved...`), así que la práctica se hizo en un PostgreSQL instalado en la computadora.
- En un PostgreSQL local, TLS viene desactivado por defecto, por eso `SHOW ssl` puede salir en `off` y `pg_stat_ssl` en `f`.

## 8. Conclusiones

Aprendí que la seguridad de una base de datos no depende solo de los permisos. Las contraseñas se tienen que guardar con hash, los datos sensibles se pueden cifrar, las conexiones se protegen con TLS y las claves se tienen que guardar aparte del código. En un entorno real usaría hash para contraseñas, cifraría los datos sensibles y los respaldos, obligaría TLS con `verify-full` y guardaría las claves en un gestor de secretos.

## Preguntas de reflexión

**1. ¿Por qué una contraseña no debe almacenarse como texto claro?**
Porque cualquiera que vea la tabla o un respaldo tendría todas las contraseñas y podría entrar como cualquier usuario.

**2. ¿Por qué un hash no es equivalente a un cifrado?**
Porque el hash no se puede revertir y el cifrado sí, con la clave.

**3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?**
Porque si un usuario tiene permiso y también tiene la clave, puede ver los datos. Además el cifrado no evita que alguien borre o modifique la información.

**4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**
Porque TLS solo protege la conexión. Una vez conectado, lo que el usuario puede hacer lo deciden los permisos.

**5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**
Ya no podría recuperar los datos cifrados con esa clave, se perderían.

**6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**
Cualquiera con acceso podría descifrar los datos. Habría que cambiar la clave y volver a cifrar todo, porque aunque se borre sigue en el historial.

**7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**
Porque lo pueden ver varias personas, se puede clonar a otras computadoras, queda todo en el historial y si alguien roba una cuenta tiene acceso a todo.

**8. ¿Qué diferencia existe entre proteger información almacenada y durante su transmisión?**
La almacenada (en reposo) se protege con cifrado en disco, columnas o respaldos. La que se transmite (en tránsito) se protege con TLS mientras viaja por la red.

**9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**
Porque aunque el algoritmo sea muy bueno, si la clave se filtra cualquiera puede descifrar los datos.

**10. ¿Qué mecanismo adicional implementarías para proteger los respaldos?**
Cifrar los respaldos con una clave guardada aparte, guardarlos en otro lugar con acceso restringido y probar seguido que se puedan restaurar.
