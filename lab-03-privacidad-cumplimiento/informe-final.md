## 1. Introducción

En los laboratorios pasados vimos cómo proteger los datos con permisos, enmascaramiento y cifrado, pero antes de eso hay que preguntarse si de verdad se ocupa tener ese dato, para qué se usa, quién lo puede ver y por cuánto tiempo se guarda. En este laboratorio se trabajó eso con la tabla clientes de la empresa Comercializadora Norte

## 2. Inventario de datos

Casi todos los campos de la tabla son datos personales. Nombre, correo, teléfono y RFC identifican directo a la persona, y edad, ciudad y código postal no la identifican solos pero juntos sí. El inventario completo está en `evidencias/01-inventario-datos.md`

## 3. Finalidades

Atención al cliente: nombre, correo y teléfono para contactar al cliente
Facturación: nombre, RFC y código postal para hacer las facturas
Analítica: ciudad y rangos de edad agrupados para estadísticas
DBA: administra la base pero no usa los datos para ninguna finalidad

## 4. Minimización

Soporte pidió una tabla con todos los campos, pero no ocupa el RFC porque eso es de facturación, tampoco la edad ni el código postal porque no sirven para atender a alguien. Por eso se hizo clientes_soporte nada más con id, nombre, correo y teléfono. El principio que se aplicó es la minimización de datos

## 5. Control de acceso

Para analítica se usaron consultas agrupadas por ciudad y por rango de edad, así ven cuántos clientes hay sin saber quién es cada uno, en vez de darles la tabla completa

Se creó el rol analista y la vista v_analitica_clientes, y al rol nada más se le dio SELECT sobre la vista

Qué puede consultar: la ciudad y el rango de edad
Si puede consultar clientes: no, no tiene permiso sobre la tabla
Si puede ver nombre, correo y RFC: no, la vista no tiene esas columnas
Principio de privacidad: minimización y limitación de finalidad
Principio de seguridad: mínimo privilegio

## 6. Derechos ARCO

Acceso: con la consulta por correo se sacan los datos del cliente, pero además se le tendría que decir para qué se usan, quién los tiene, si se pasaron a alguien y por cuánto tiempo se guardan
Rectificación: se cambió nada más el correo del cliente 1. Para comprobar que el cambio estaba autorizado tiene que haber una solicitud aprobada y se tendría que registrar quién lo hizo y cuándo, porque sin trazabilidad no se puede saber si alguien cambió datos sin permiso
Cancelación: antes de borrar hay que revisar respaldos, réplicas, reportes, exportaciones y otros sistemas, porque borrar de la tabla no borra todas las copias (`evidencias/08-ciclo-vida.md`)
Oposición: no hace falta borrar todos sus datos. Se tienen que quedar los que se ocupan para la operación o lo que pida la ley, como las facturas, y nada más se deja de usar el dato para la finalidad a la que se opuso, por ejemplo con un campo que marque que no quiere promociones y filtrando con eso en las vistas. La decisión no la toma solo el DBA porque es algo legal y de la organización, el DBA nada más hace la parte técnica

## 7. Retención

Guardar todo para siempre va contra la minimización. El periodo se tiene que definir por cada dato según para qué se usa, lo que pida la ley y qué se hace cuando se termina el plazo, y eso se documenta junto con quién lo autorizó (`evidencias/10-retencion.md`)

## 8. Gobierno de datos

Cada dato tiene un área responsable y solo lo ven las áreas que lo ocupan. La matriz y la tabla de controles técnicos y administrativos están en `evidencias/11-gobierno-datos.md`

## 9. Evaluación integral

Los riesgos más fuertes del escenario son que analítica ve la tabla completa, que los datos se guardan desde hace 12 años sin política, que los desarrolladores tienen copias con datos reales y que marketing usa los correos sin saber si puede. La tabla completa está en `evidencias/14-evaluacion-integral.md` y la propuesta de arquitectura en `evidencias/15-arquitectura.md`

## 10. Conclusiones

Aprendí que la seguridad y la privacidad no son lo mismo. La seguridad cuida que nadie entre sin permiso y la privacidad ve si de verdad se deben tener y usar los datos. Una base puede estar bien protegida y aun así guardar datos de más o usarlos para otra cosa. El DBA hace la parte técnica pero las decisiones de finalidad y retención las toman otras áreas

## Preguntas de reflexión

**1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?**

No, puede estar bien protegida pero guardar datos que no ocupa, usarlos para otra finalidad o guardarlos para siempre

**2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?**

Porque si cada quien ve solo lo que ocupa, menos personas tienen acceso a los datos personales

**3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?**

Porque eso depende de la ley, del aviso de privacidad y de la organización, el DBA solo administra la parte técnica

**4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?**

Porque para probar no ocupan datos reales, con datos de prueba o enmascarados es suficiente

**5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?**

Porque tiene los mismos datos reales pero en equipos con menos protección y casi nunca se borra

**6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?**

Porque los datos no se tienen que guardar para siempre, hay que saber cuándo se borran o se anonimizan

**7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?**
Que desde que se hacen las tablas se decide qué datos se guardan, así que ahí mismo se tiene que pensar en guardar solo lo necesario

**8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?**

Roles con mínimo privilegio, vistas con lo necesario, cifrado de datos sensibles, enmascaramiento, auditoría y borrar lo que ya no se ocupa

**9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?**

En qué tablas está el dato, en qué respaldos, réplicas y exportaciones, quién lo usa y qué está autorizado a hacer con la solicitud

**10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?**

El DBA aplica los controles técnicos, el responsable de privacidad atiende las solicitudes y revisa que se cumpla, el área jurídica dice qué pide la ley y el propietario de los datos decide para qué se usan y quién los ve