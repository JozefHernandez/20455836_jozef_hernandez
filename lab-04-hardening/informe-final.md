# Informe LAB-04 Hardening

**1. ¿Cuál era la principal superficie de ataque?**

Que PostgreSQL escuchaba en todas las interfaces con listen_addresses en '*', o sea que aceptaba conexiones por cualquier red de la compu aunque solo se ocupaba localhost.

**2. ¿Qué configuración representaba el mayor riesgo?**

listen_addresses en '*' porque si después se agrega una regla amplia en pg_hba.conf o se abre el firewall el servidor queda expuesto.

**3. ¿Qué cambio produjo la mayor reducción de exposición?**

Cambiar listen_addresses a 'localhost', porque con eso ya no se puede llegar desde la red.

**4. ¿Qué diferencia existe entre firewall y pg_hba.conf?**

El firewall bloquea la conexión antes de que llegue a PostgreSQL y pg_hba.conf decide quién se puede autenticar, a qué base, desde dónde y con qué método.

**5. ¿Qué diferencia existe entre autenticación y autorización?**

La autenticación comprueba quién eres y la autorización decide qué puedes hacer ya que entraste.

**6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**

Porque si la aplicación se compromete el atacante tiene permiso para hacer todo en la base.

**7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**

Porque un escaneo encuentra el puerto nuevo rápido, solo quita un poco de ruido pero no cambia quién se puede conectar ni con qué permisos.

**8. ¿Por qué listen_addresses='*' puede ser innecesario?**

Porque si solo se conecta la misma compu o una red específica no tiene caso escuchar en todas las interfaces.

**9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**

Ahí están los archivos de datos y de configuración, si otro usuario del sistema los puede leer o cambiar se brinca los permisos de PostgreSQL.

**10. ¿Qué controles deberían revisarse periódicamente?**

pg_hba.conf, listen_addresses, roles y privilegios, extensiones, TLS, permisos de los archivos, reglas del firewall y las actualizaciones de PostgreSQL.

## Reflexión

**¿Qué cambiarías primero si recibieras la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción?**

Primero revisaría y cerraría el acceso de red, o sea el firewall y pg_hba.conf, para que solo se conecten las redes y usuarios que de verdad lo ocupan. Es lo que más reduce el riesgo porque quita la exposición a internet, que es por donde entran la mayoría de los ataques. No lo haría de golpe, primero vería qué conexiones se usan de verdad para no tumbar a la aplicación y afectar la disponibilidad, y aplicaría los cambios en una ventana de mantenimiento con forma de regresarlos. Después seguiría con la cuenta de la aplicación, porque si tiene privilegios de administrador cualquier falla es grave, y eso sí requiere coordinarse con los desarrolladores para no romper la continuidad del servicio. La autenticación con scram-sha-256 y TLS los dejaría después porque dependen de que los clientes los soporten