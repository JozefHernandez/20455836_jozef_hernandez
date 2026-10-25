# Activad 5: Analizar una finalidad secundaria

**1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?**

Tener los datos no te deja usarlos los datos se recabaron para atender y facturar a los clientes, y esas son las finalidades que el aviso de privacidad les informó.

**2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?**

¿Quién accederá a los datos, con qué permisos y con qué registro?
¿Se compartirán con terceros?
¿Cuánto tiempo se conservarán los perfiles y cómo se atenderán las solicitudes de baja?
¿Se incluye a menores de edad?
¿Qué se busca lograr exactamente? 
¿Se puede lograr con menos datos o con datos agregados?
¿Los clientes dieron su consentimiento o tuvieron la opción de negarse? 
¿Cómo se registra esa decisión?

**3. ¿Qué datos serían realmente necesarios?**

Medio de contacto, edad, ciudad, comportamiento de compras, estatus de consentimiento

**4. ¿Necesitaría el área de marketing acceso directo a clientes?**

No la tabla contiene datos que Marketing no necesita y contradice el minimo privilegio

**5. ¿Qué controles técnicos podrían limitar la información entregada?**

Tablas de consentimiento, Rol propio de Marketing con mínimo privilegio, sin permisos sobre la tabla base ni sobre el RFC.
Seudonimización: que la herramienta de campañas reciba un identificador sustituto y solo reciba el correo en el momento del envío, generalización y resumen rangos de edad y categorías de compra en lugar de valores exactos o detallados, cifrado y enmascaramiento de los campos sensibles que permanecen en la base.

# Activad 6: Derechos ARCO y la base de datos

**¿Qué información adicional debería proporcionar la organización además del resultado de esta consulta?**

Ademas del resultado de la consulta la organizacion debe integrar datos distribuidos en otras tablas o microservicios como compras o tickets de soporte proporcionar metadatos de conservacion y fuente de origen mapear las transferencias a sistemas de terceros entregar los archivos en formatos estructurados como JSON o CSV y garantizar la trazabilidad mediante archivos cifrados y logs de auditoria.

# Activad 7: Derecho de rectificacion

**¿Cómo podría comprobarse que el cambio fue autorizado?**

Por mecanismos de autenticacion y confirmacion comprobando que la solicitud provino de una sesion autenticada del cliente o con autenticacion multifactor.

**¿Debería registrarse quién realizó el cambio?**

Si debe guardarse un registro que identifique quien fue el responsable por seguridad.

**¿Por qué la trazabilidad será importante?**

Por seguridad y deslinde de responsabilidades en caso de accesos sin autorizacion se puede saber que fue lo que fallo.