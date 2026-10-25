# Actividad 12: Privacidad por diseño

**¿Qué problemas identificas?**

Se guardan datos que no se necesitan, como salario, estado civil, ocupación y fecha de nacimiento. No hay llave primaria ni NOT NULL y todo es TEXT, entonces no hay control de qué se guarda. Además se repite la edad con la fecha de nacimiento.

**¿Qué principio de privacidad se está ignorando?**

La minimización de datos, y también la finalidad.

**¿Qué preguntas realizarías antes de aprobar el diseño?**

¿Para qué se va a usar cada campo?
¿Qué área lo ocupa?
¿Qué dice el aviso de privacidad?
¿Por cuánto tiempo se va a guardar?
¿Quién va a tener acceso?

**¿Qué datos eliminarías?**

Salario, estado civil, ocupación y la edad, porque si de verdad se ocupa se saca de la fecha de nacimiento.

**¿Qué datos requerirían una justificación adicional?**

La fecha de nacimiento, la dirección y el RFC, porque solo se ocupan para cosas específicas como facturar o enviar algo.

**¿Cómo aplicarías privacidad por defecto?**

Que los campos opcionales empiecen vacíos, que solo se pidan los datos obligatorios, que ningún rol tenga acceso a la tabla hasta que se le dé y que las demás áreas vean la información por vistas con lo mínimo.

# Actividad 13 Controles técnicos y administrativos

| Medida | Técnico | Administrativo |
|---|---|---|
| Crear roles de PostgreSQL | Sí | |
| Política de retención | | Sí |
| Cifrado de datos | Sí | |
| Procedimiento para solicitudes ARCO | | Sí |
| Vista con información limitada | Sí | |
| Clasificación de información | Sí | Sí |
| Registro de auditoría | Sí | |
| Política de control de acceso | Sí | Sí |