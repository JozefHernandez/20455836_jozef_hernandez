## Tabla resuelta

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
| --- | --- | --- | --- | --- | --- |
| id | Sí | Identificar de forma única al cliente y relacionar registros | Sí | Atención: Lectura · Facturación: Lectura · Analítica: Sin acceso al id real · DBA: Técnico | Mientras exista la relación; se elimina o desvincula al darse de baja |
| nombre | Sí | Identificar al cliente en la atención y como receptor en la factura | Sí | Atención: Lectura · Facturación: Lectura · Analítica: Sin acceso · DBA: Técnico | Relación + 5 años |
| correo | Sí | Contactar al cliente y, en su caso, enviarle comprobantes | Sí | Atención: Lectura · Facturación: Lectura solo si la factura se envía por correo; si no, sin acceso · Analítica: Sin acceso · DBA: Técnico | Mientras exista la relación |
| telefono | Sí | Contacto directo para atención y seguimiento | Condicional | Atención: Lectura · Facturación: Sin acceso · Analítica: Sin acceso · DBA: Técnico | Mientras exista la relación; se elimina al baja |
| rfc | Sí | Emitir facturas y cumplir obligaciones fiscales | Sí, para facturación | Atención: Enmascarado, solo si necesita verificar al cliente · Facturación: Lectura · Analítica: Sin acceso · DBA: Técnico, con campo cifrado | 5 años después eliminación o bloqueo |
| edad | Sí | Segmentación estadística | No para atención ni facturación; sí para analítica, en rangos | Atención: Sin acceso · Facturación: Sin acceso · Analítica: Agregado · DBA: Técnico | Relación activa; para analítica, conservar solo rangos agregados |
| ciudad | Sí | Dar contexto básico en la atención y generar estadísticas por zona | Sí para analítica; condicional para atención | Atención: Lectura · Facturación: Sin acceso · Analítica: Agregado · DBA: Técnico | Relación activa; en analítica, conservar solo agregada |
| codigo_postal | Sí | Domicilio fiscal en la factura y estadísticas por zona | Sí para facturación condicional para analítica | Atención: Sin acceso · Facturación: Lectura · Analítica: Agregado · DBA: Técnico | Relación + 5 años si se usa como dato fiscal; en analítica, solo agregado |
| fecha_alta | No por sí sola; se protege al estar ligada al cliente | Calcular antigüedad, plazos de retención y estadísticas de altas | Sí | Atención: Lectura · Facturación: Sin acceso · Analítica: Agregado por mes o año · DBA: Técnico | Mientras exista el registro; es la base para calcular plazos de retención |

## Justificación

### id

- **¿Dato personal?** Sí, apunta a un cliente identificable al combinarse con el resto de los campos.
- **Finalidad:** Es el identificador interno que permite que Atención y Facturación trabajen sobre el mismo cliente y que se atiendan solicitudes.
- **¿Necesario?** Sí, es un requisito técnico de la base.
- **Acceso:** Atención y Facturación lo requieren para localizar registros.
- **Retención:** acompaña la cuenta al eliminarla se desvincula o elimina.

### nombre

- **¿Dato personal?** Sí, es el identificador más directo de una persona.
- **Finalidad:** identificar al cliente en la atención y aparecer como receptor en la factura.
- **¿Necesario?** Sí para ambos procesos.
- **Acceso:** Lo consultan Atención y Facturación, porque ambos lo mencionan expresamente.
- **Retención:** Durante la relación y 5 años después ya que forma parte del soporte de comprobantes fiscales.

### correo

- **¿Dato personal?** Sí, identifica y permite contactar a la persona.
- **Finalidad:** Comunicarse con el cliente en la atención y si aplica enviar la factura electrónica.
- **¿Necesario?** Sí, es parte de la información de contacto que Atención consulta.
- **Acceso:** Atención lo lee. Facturación lo necesita solo si la empresa envía facturas por correo.
- **Retención:** Mientras el cliente tenga relación con la empresa se elimina al darse de baja salvo obligación legal.
- **Uso:** El correo recolectado para atención y facturación no debe usarse para marketing sin consentimiento específico.

### telefono

- **¿Dato personal?** Sí, permite identificar y localizar a la persona.
- **Finalidad:** Contacto directo en atención al cliente.
- **¿Necesario?** Condicional: solo lo requiere Atención.
- **Acceso:** Unicamente Atención en lectura.
- **Retención:** Mientras dure la relación.

### rfc

- **¿Dato personal?** Sí, y de alta sensibilidad en la práctica: vincula a la persona con su situación fiscal y facilita fraude o suplantación.
- **Finalidad:** Emitir facturas (CFDI) y cumplir obligaciones fiscales.
- **¿Necesario?** Sí para Facturación. Idealmente solo debería capturarse a clientes que soliciten factura.
- **Acceso:** Facturación en lectura. Atención solo lo necesitaría enmascarado, el DBA gestiona el campo cifrado, sin descifrarlo para usos funcionales.
- **Retención:** 5 años, conforme al plazo general de conservación de comprobantes y contabilidad del Código Fiscal de la Federación. Después, eliminación o bloqueo seguro.

### edad

- **¿Dato personal?** Sí, es información sobre una persona identificada.
- **Finalidad:** Estadísticas de segmentación y solo si el negocio lo exige comprobar mayoría de edad.
- **¿Necesario?** No para Atención ni Facturación sí para Analítica, pero en rangos de 18-25, 26-35, etc. y no como edad exacta.
- **Acceso:** Analítica solo agregado.
- **Retención:** Mientras dure la relación.

### ciudad

- **¿Dato personal?** Sí, junto con otros campos ayuda a identificar a la persona.
- **Finalidad:** Contexto básico en la atención y estadísticas por zona.
- **¿Necesario?** Sí para analítica, condicional para atención.
- **Acceso:** Atención en lectura, Analítica solo agregada.
- **Retención:** Mientras dure la relación, en analítica se conserva agregada o anonimizada.

### codigo_postal

- **¿Dato personal?** Sí, puede reidentificar combinada con otros datos.
- **Finalidad:** domicilio fiscal en la factura y estadísticas geográficas.
- **¿Necesario?** Sí para Facturación, siempre que sea el código postal del domicilio fiscal del cliente.
- **Acceso:** Facturación en lectura, analítica solo agregado.
- **Retención:** 5 años cuando se usa como dato fiscal.

### fecha_alta

- **¿Dato personal?** Por sí sola no, pero al estar ligada a un cliente identificable se protege como parte de su registro.
- **Finalidad:** conocer la antigüedad del cliente, calcular los plazos de retención y generar estadísticas de altas.
- **¿Necesario?** Sí, es clave para cumplir las políticas de conservación y demostrar responsabilidad.
- **Acceso:** Atención la consulta, analítica la usa agregada por mes o año.
- **Retención:** mientras exista el registro.

## Actividad 2 — Principio de minimización

### 1. ¿Todos los campos son necesarios para atención al cliente?

No según lo que Atención necesita consultar la tabla tiene campos de sobra.

### 2. ¿Por qué soporte necesitaría conocer el RFC?

No lo necesita porque el RFC es un dato fiscal y esa finalidad le corresponde a otra área tenerlo solo aumenta el riesgo. Si en algún caso soporte debe confirmar la identidad del cliente, basta con mostrarlo enmascarado o validar con otro dato, sin exponer el RFC completo.

### 3. ¿Necesita conocer la edad?

No para resolver alguna consulta o incidencia la edad no influye.

### 4. ¿Necesita conocer el código postal?

No el código postal sirve para el domicilio fiscal en la factura (Facturación) y para estadísticas por zona (Analítica). 

### 5. ¿Qué principio de privacidad está relacionado con esta decisión?

El principio de proporcionalidad que dice que solo debe tratarse la información necesaria, adecuada y relevante para la finalidad que se persigue.

## Actividad 3

### Pregunta

**¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?**

Porque estas consultas entregan resultados agregados y no registros individuales mientras que Analítica necesita estadísticas no saber quién es cada cliente.

## Actividad 4

### Preguntas

**¿Qué información puede consultar el rol?**

La consulta final contra information_schema.role_table_grants

**¿Puede consultar directamente clientes?**

Sí por GRANT SELECT ON clientes TO analista

**¿Puede obtener nombre, correo y RFC?**

Sí porque se le dieron los permisos

**¿Qué principio de privacidad estás aplicando?**

La minimización de datos: la vista expone solo lo necesario para estadística y convierte la edad exacta en un rango

**¿Qué principio de seguridad estás aplicando?**

El mínimo privilegio: El rol recibe solo los permisos necesarios Se complementa con need-to-know y con aplicar el control en la propia base de datos y no confiar en que el analista no consulte lo que no debe.