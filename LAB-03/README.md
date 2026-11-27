# LAB-03 — Políticas prácticas, gobierno de datos y evidencias

PostgreSQL 16 y MongoDB 7 Community en Docker, la misma base comercial del LAB-01 y LAB-02
**Jozef Alejandro Hernandez Aguilar**

- `EXPEDIENTE.md` es el expediente de auditoría
- `sql/` tiene las consultas de calidad, diccionario, inventario y registro de cambios
- `politicas/` tiene POL-01 a POL-06
- `evidencias/` tiene los resultados de cada actividad, E1 a E5 y la carpeta `E6-mongodb`

## Preguntas de reflexión

**1. ¿Por qué el gobierno de datos no es "burocracia" frente al problema inicial de la unidad?**
El problema era que cambiaron el RFC de María García y nadie supo decir de quién era el dato ni quién podía cambiarlo. Con propietario, folios y bitácora esa pregunta ya tiene respuesta. No es papeleo, es lo que permite investigar

**2. ¿Qué diferencia hay entre el propietario técnico de una tabla y el propietario del dato?**
El técnico es el rol que creó la tabla en el motor, aquí `postgres`. El del dato es el área que decide para qué se usa y quién lo ve, aquí la Gerencia Comercial

**3. ¿Por qué una política sin evidencia no supera una auditoría?**
Porque el auditor no puede revisar una intención. Si la política dice que se revisan los permisos cada 3 meses pero no hay acta, no hay forma de probar que se hizo. Por eso en POL-02 y POL-04 puse "hoy no existe"

**4. ¿Qué parte del expediente sería la más difícil de mantener actualizada y cómo lo resolverías?**
La conciliación, porque cada `GRANT` o `ALTER` nuevo hay que compararlo con un folio. Lo haría con la consulta de `04-registro-cambios.sql` corriendo cada mes y que la revise alguien distinto del DBA

**5. ¿Qué hallazgo de tu expediente tiene mayor impacto y por qué?**
H-07, el periodo sin registro. Por eso no se puede saber quién cambió el RFC de María García, y es justo la pregunta que empezó todo

**6. ¿Por qué documentar una limitación es mejor que ocultarla?**
Porque si el auditor la encuentra solo, pierdes credibilidad en todo lo demás. Si la declaras con su control compensatorio, se ve que sabes dónde están los huecos y alguien puede decidir si acepta el riesgo