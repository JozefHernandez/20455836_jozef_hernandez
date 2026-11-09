# Errores

## 1. ¿El intento de `soporte_ana` causó algún daño? ¿Por qué debe auditarse de todos modos?
No causó ningún daño, el servidor rechazó la sentencia antes de ejecutarla de modo que el registro con `id = 5` sigue existiendo y ningún dato cambió y deberia auditarse 

## 2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?
La diferencia está en qué se comprueba y en qué momento ocurre. La **autenticación** verifica quién eres. El error de la Actividad 5 ocurre porque al abrir la conexión el servidor evalúa la regla de pg_hba.conf y la credencial y si no coinciden la sesión nunca llega a existir.
La **autorización** verifica qué puedes hacer. El error de esta actividad ocurre con la sesión ya establecida y la identidad ya confirmada: soporte_ana entró correctamente, con su contraseña, y fue el rol el que no tenía el privilegio.

## 3. ¿Qué indica el error de `DROP ROLE` sobre el orden correcto para dar de baja a un usuario?
Indica que un rol no puede eliminarse mientras tenga objetos o privilegios que dependan de él. PostgreSQL protege así la integridad de los permisos, si permitiera borrar el rol, quedarían concesiones sin destinatario o objetos sin propietario