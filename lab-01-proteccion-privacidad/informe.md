# Informe: Protección de datos personales en la tabla clientes

---

## 19.1 Clasificación

### Qué datos requieren protección

Todos los campos de la tabla requieren protección, porque se refieren a una persona física identificada o identificable. Se clasifican así:

| Campo | Identifica directamente | Contribuye a identificar | Requiere protección | Justificación |
| --- | --- | --- | --- | --- |
| `id` | No | Sí | Sí | Es un identificador técnico; por sí solo no revela a la persona, pero quien tenga acceso a más sistemas con el `id` puede vincular registros. |
| `nombre` | Sí | Sí | Sí | Es el identificador más evidente; combinado con cualquier otro campo identifica todo el registro. |
| `correo` | Sí | Sí | Sí | Es único por persona y puede contener datos personales como el nombre. |
| `telefono` | Sí | Sí | Sí | Es único por persona; permite el contacto y, por la lada, el cruce con otra información. |
| `rfc` | Sí | Sí | Sí | Se deriva del nombre y de la fecha de nacimiento; es un identificador único. |
| `edad` | No | Sí | Sí | Es un dato genérico, pero reduce el número posible de personas. |
| `ciudad` | No | Sí | Sí | Es ubicación geográfica; en una base pequeña delimita mucho la búsqueda. |
| `codigo_postal` | No | Sí | Sí | Acota la ubicación a una zona reducida y, con otros datos, permite reidentificar. |
| `fecha_alta` | No | Sí | Sí | Revela cuándo la persona fue cliente; por sí sola aporta poco, pero sirve para relacionar registros. |

### Por qué requieren protección

- **Identificadores directos** (`nombre`, `correo`, `telefono`, `rfc`): permiten señalar a una persona concreta sin información adicional.
- **Atributos que contribuyen a identificar** (`id`, `edad`, `ciudad`, `codigo_postal`, `fecha_alta`): con ninguno se señala a una persona, pero **reducen el número de candidatos**, y su combinación puede aislar a un individuo.
- **Combinaciones que aumentan el riesgo de reidentificación:**
  - `codigo_postal` + `edad` (o fecha de nacimiento).
  - `ciudad` + `fecha_alta` + otros atributos.
  - `rfc` + cualquier otro dato.
  - `correo` o `telefono` + datos externos.
- **Sensibilidad jurídica:** que un dato requiera protección **no** significa que sea un dato personal sensible. Son conceptos distintos. `nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad` y `codigo_postal` son datos personales de identificación y contacto; aun así requieren protección, y un dato no sensible puede implicar riesgos altos.

---

## 19.2 Enmascaramiento

### Qué se ocultó

Se creó la vista `v_clientes_soporte`, que muestra solo cinco columnas: `id`, `nombre`, `correo`, `telefono` y `rfc`. De ellas, tres están enmascaradas parcialmente:

| Campo | Ejemplo original | Valor mostrado |
| --- | --- | --- |
| `correo` | `ana.lopez@example.test` | `an*****@example.test` |
| `telefono` | `6671234567` | `******4567` |
| `rfc` | `LOAA850315ABC` | `*********5ABC` |

Además, **no se exponen** `edad`, `ciudad`, `codigo_postal` ni `fecha_alta`.

### Para quién

Para el rol `soporte`, que puede consultar el esquema `public` y la vista `v_clientes_soporte`. Ve el `id`, el nombre completo, las dos primeras letras del correo, los últimos 4 dígitos del teléfono y los últimos 4 caracteres del RFC.

### Por qué

- **Mínimo privilegio:** soporte recibe solo lo necesario para atender al cliente.
- **Reducción del riesgo** de fraude, suplantación y fuga por parte de usuarios internos.
- **Verificación sin exposición:** el final del teléfono o el inicio del correo bastan para confirmar la identidad.
- **No basta con ocultar los datos en la aplicación:** la aplicación es solo una vía de acceso a la base de datos; quien tenga otra forma de conectarse vería los datos completos sin ningún problema.

### Mecanismo utilizado

1. `CREATE ROLE soporte NOLOGIN` para crear el rol.
2. `CREATE VIEW v_clientes_soporte` con funciones de texto (`LEFT`, `RIGHT`, `SUBSTRING`, `POSITION`, `CONCAT`) aplicadas al consultar.
3. `GRANT USAGE ON SCHEMA public TO soporte` y `GRANT SELECT ON v_clientes_soporte TO soporte`.
4. `REVOKE ALL ON clientes FROM soporte` para dejar explícito que no hay acceso directo a la tabla base.

### Verificación

- La consulta a la vista devuelve los 5 registros con los valores enmascarados.
- Después de `SET ROLE soporte`, la consulta `SELECT * FROM clientes` falla con `ERROR: permission denied for table clientes` (`SQLSTATE 42501`).

### Qué ocurriría si soporte tuviera acceso directo a `clientes`

Podría ver los datos completos de cada cliente y, según los privilegios concedidos, también modificarlos o borrarlos, afectando la integridad de la información.

### Limitaciones del enmascaramiento

- **La tabla original conserva todos los datos sin enmascarar.** La vista es solo una consulta guardada: el enmascaramiento ocurre al consultar, no al almacenar.
- Mostrar los últimos 4 caracteres del RFC deja visible parte de la homoclave y, según el caso, del día de nacimiento.
- El `nombre` completo combinado con los fragmentos de correo y teléfono sigue siendo un perfil muy identificable.
- `CONCAT` convierte `NULL` en cadena vacía, por lo que un teléfono o RFC nulo se mostraría como `******`.
- La vista funciona porque, por defecto, se ejecuta con los permisos de su propietario.

---

## 19.3 Seudonimización

### Cómo se generaron los tokens

Se crearon los esquemas `pii` y `analitica`, y la tabla `pii.mapa_cliente`. Después se insertó un **UUID aleatorio** por cliente con `gen_random_uuid()` a partir de `clientes`, lo que generó 5 tokens. Como el token es aleatorio, **no se puede derivar** del dato original sin consultar el mapa. (`gen_random_uuid()` es nativa desde PostgreSQL 13; `pgcrypto`, que también se habilitó con `CREATE EXTENSION IF NOT EXISTS pgcrypto`, solo es necesaria en versiones anteriores.)

### Dónde se encuentra el mapa de correspondencia

En `pii.mapa_cliente`, con la estructura `token` (`UUID`, clave primaria) y `cliente_id` (`BIGINT`, único, con llave foránea a `public.clientes(id)`). Está en un **esquema separado** (`pii`) del de análisis.

La tabla `analitica.clientes` se creó con `CREATE TABLE ... AS` mediante un `JOIN` entre `pii.mapa_cliente` y `clientes`. Contiene solo `cliente_token`, `edad`, `ciudad`, `codigo_postal` y `fecha_alta`: sin nombre, correo, teléfono, RFC ni `id`.

### Quién debería poder acceder al mapa

Únicamente un **rol de custodia** (por ejemplo, `custodio_pii`) o el responsable de protección de datos, con:

- acceso restringido y justificado,
- registro de auditoría de cada consulta,
- idealmente, aprobación para cada reidentificación.

### Separación de funciones (rol `analista`)

Se creó el rol `analista` (`NOLOGIN`) con `GRANT USAGE ON SCHEMA analitica` y `GRANT SELECT ON analitica.clientes`. La verificación mostró:

| Consulta del rol `analista` | Resultado |
| --- | --- |
| `SELECT * FROM analitica.clientes` | Devuelve los 5 registros con token y atributos |
| `SELECT * FROM pii.mapa_cliente` | `permission denied for schema pii` |
| `SELECT * FROM public.clientes` | `permission denied for table clientes` |

### Por qué se separaron los permisos

- Quien analiza los datos **no debe poder reidentificar** a las personas.
- Se aplican **mínimo privilegio** (el analista recibe solo lo que necesita) y **separación de funciones** (quien analiza no es quien puede reidentificar; eso queda en manos de otro rol).
- Si `analista` pudiera consultar `pii.mapa_cliente`, la seudonimización quedaría **anulada en la práctica**: obtendría el `cliente_id` de cada registro y, aunque `clientes` siga protegida, el `id` ya es un enlace directo a la persona.

### Qué información permite volver a relacionar el token con una persona

- A partir del `cliente_id` del mapa se llega al `nombre`, `correo`, `telefono` y `rfc`.
- Los cuasi-identificadores de `analitica.clientes` (`edad`, `ciudad`, `codigo_postal` y `fecha_alta`) también permiten reidentificar **sin usar el mapa**.

### Limitaciones de la seudonimización

- Los datos seudonimizados **siguen siendo datos personales**, porque existe una forma de revertir el proceso.
- La seudonimización reemplaza los identificadores directos por un token; la anonimización, en cambio, es irreversible y la persona deja de ser identificable por medios razonables.
- `analitica.clientes` es una copia puntual (`CREATE TABLE ... AS`) y no se actualiza sola; además, `cliente_token` no tiene clave primaria definida.

---

## 19.4 Anonimización

### Qué identificadores fueron eliminados

En las consultas agregadas (conteos por grupo) ya no aparecen `id`, `nombre`, `correo`, `telefono` ni `rfc`. El resultado solo muestra categorías y totales.

> Esto aplica **al resultado**. La tabla `clientes` no cambió y conserva todos los identificadores.

### Qué atributos fueron generalizados

| Atributo original | Generalización aplicada |
| --- | --- |
| `edad` | Rangos: `18-30`, `31-45`, `46+` |
| `codigo_postal` | Solo los 2 primeros dígitos (`region`) |
| `ciudad` y `fecha_alta` | No se incluyen en el resultado (supresión del atributo) |

### Resultados con los datos de ejemplo

| Consulta | Resultado |
| --- | --- |
| Solo rango de edad | `31-45`: 4, `46+`: 1 |
| Solo región | `80`: 3, `81`: 1, `82`: 1 |
| Rango de edad + región | `31-45 / 80`: 3, `31-45 / 81`: 1, `46+ / 82`: 1 |
| Rango de edad + región, con `HAVING COUNT(*) >= 5` | 0 filas |

### Qué grupos fueron suprimidos

La cláusula `HAVING COUNT(*) >= 5` aplica un umbral de **k ≥ 5** y suprime todo grupo con menos de 5 registros. Con solo 5 clientes, **todos los grupos son suprimidos** y la consulta no devuelve filas. El resultado es seguro pero inútil para el análisis: el problema es el volumen de datos, no la técnica.

### Qué riesgo de reidentificación permanece

- **Cuasi-identificadores que permanecen:** `rango_edad` (derivado de `edad`) y `region` (derivada de `codigo_postal`).
- **Sin umbral (consulta combinada):** hay grupos de tamaño 1. `46+ / 82` y `31-45 / 81` corresponden cada uno a una sola persona. Quien conozca a un cliente de ese perfil lo identifica de inmediato.
- **Divulgación de atributos:** con grupos pequeños el riesgo sigue siendo alto; si todas las personas de un grupo comparten una característica, se conoce ese dato de cualquiera de ellas.
- **Combinar la salida con otros datos** (`ciudad`, `fecha_alta` o el `codigo_postal` completo) haría los grupos aún más pequeños.
- **Datos originales intactos:** quien tenga acceso a `clientes` puede revertir cualquier agregación.
- **Población muy pequeña:** con 5 registros no existe anonimato real; nadie "se pierde entre la multitud".
- **Conclusión:** no es correcto afirmar que el conjunto sea "100 % anónimo". Lo defendible sería hablar de un **riesgo reducido bajo ciertos supuestos** (k ≥ 5 y generalización aplicada), que en este ejemplo solo se cumplen en la consulta que suprime todo.

### Mejoras recomendadas

- **Generalizar más:** rangos de edad más amplios; del `codigo_postal`, solo el primer dígito o municipio/estado; la `ciudad` por zona o estado; la `fecha_alta` reducida al año.
- **Suprimir** `nombre`, `correo`, `telefono`, `rfc` e `id`, y los grupos con menos de *k* personas (o fusionarlos con otros).
- Aplicar supresión complementaria si se publican totales junto con los grupos.
- Considerar l-diversidad, t-cercanía o privacidad diferencial.
- Corregir el `CASE`: `ELSE '46+'` también captura edades menores de 18 y valores `NULL`.

---

## 19.5 Retención

### Qué criterio se utilizó

Se propuso eliminar los registros con `fecha_alta` anterior a la fecha actual menos 5 años:

```sql
SELECT *
FROM clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';
```

Con fecha de hoy (18 de octubre de 2026), el corte es el **18 de octubre de 2021**. Con los datos de ejemplo **no se afecta ningún registro** (la consulta devuelve 0 filas), porque todos tomaron `DEFAULT CURRENT_DATE` al insertarse.

**Justificación del periodo:**

- Principios de **finalidad y proporcionalidad**: los datos se conservan solo mientras sean necesarios para la finalidad informada en el aviso de privacidad. Cumplida la finalidad, procede la cancelación.
- **Obligaciones legales de conservación** (por ejemplo, la normativa fiscal mexicana suele exigir conservar contabilidad y comprobantes por 5 años); existen plazos distintos en materia mercantil, laboral o de prevención de lavado de dinero, y deben verificarse con el área legal porque dependen del tipo de relación.
- **Plazos de prescripción:** periodo en que podrían surgir reclamaciones.

**Limitación del criterio:** `fecha_alta` es la fecha de alta, no de la última actividad. Un cliente dado de alta hace 6 años que compró la semana pasada seguiría activo. El criterio más adecuado sería la **última actividad o la terminación de la relación**.

### Verificación de accesos tras definir la política

| Rol | Puede consultar | No puede consultar |
| --- | --- | --- |
| `soporte` | `v_clientes_soporte` | `clientes` (`permission denied for table clientes`) |
| `analista` | `analitica.clientes` | `pii.mapa_cliente` (`permission denied for schema pii`) y `public.clientes` (`permission denied for table clientes`) |

### Qué información debería conservarse

- Datos sujetos a **obligaciones legales vigentes** (fiscales, mercantiles, de prevención de lavado de dinero, etc.).
- Datos de clientes con **relación activa**.
- Datos sujetos a **retención legal** por litigios, auditorías o requerimientos de autoridad.
- **Evidencia de la depuración** (no los datos personales eliminados): que ocurrió y estuvo autorizada.
- Datos agregados que ya no permiten identificar a nadie, si se demostró que la anonimización es efectiva.

### Qué información podría eliminarse

- Registros de clientes cuya relación terminó y cuyo plazo legal y de negocio ya venció.
- Todo lo que dependa de esos registros:

| Ubicación | Acción |
| --- | --- |
| `analitica.clientes` | Eliminar por `cliente_token` |
| `pii.mapa_cliente` | Eliminar (la llave foránea bloquea el `DELETE` en `clientes` si se hace antes) |
| `public.clientes` | Eliminar al final |
| Respaldos, réplicas, logs y exportaciones | Depurar según su propio plan, con fecha de caducidad |

Orden correcto: `analitica.clientes` → `pii.mapa_cliente` → `clientes` (o definir `ON DELETE CASCADE`). En México la cancelación implica un **periodo de bloqueo** antes de la supresión definitiva.

### Qué controles deberían existir antes de eliminarla

1. **Aprobación formal** (con fecha, alcance, criterio y firma) de:
   - el dueño de los datos o área de negocio, que confirma que ya no se necesitan;
   - el área legal o de cumplimiento, que confirma que no hay litigios, auditorías ni requerimientos de autoridad en curso;
   - el responsable de protección de datos, que valida que se alinea con la política de retención y el aviso de privacidad;
   - el responsable técnico o DBA, que confirma el alcance, el impacto y el plan de reversión.
2. **Respaldo completo y verificado** antes de ejecutar, que incluya `public.clientes`, `pii.mapa_cliente` y `analitica.clientes`, con prueba de restauración en un entorno aparte.
3. **Copia de los registros a eliminar** en un esquema restringido, para recuperación ante error.
4. **Ejecución dentro de una transacción** (`BEGIN`), verificando conteos antes de `COMMIT`.
5. **Evidencia** de que la depuración ocurrió y estuvo autorizada: política aplicada, consulta, conteo previo y posterior, quién ejecutó y cuándo, registros de auditoría y reporte de cierre firmado. Se usan `COUNT(*)` e identificadores técnicos, no `SELECT *`.

### Procedimiento de recuperación ante eliminación accidental

1. **Detener** cualquier proceso de depuración adicional y avisar al responsable.
2. **Evaluar el alcance:** qué se borró, cuándo y por quién.
3. **Recuperar desde la fuente adecuada:** si el error afecta a pocos registros, reinsertar solo lo necesario desde la tabla de archivo; en otro caso, restaurar el respaldo en un entorno aparte y extraer únicamente los registros afectados.
4. **Restaurar en orden de dependencias,** respetando las llaves foráneas: primero `public.clientes`, luego `pii.mapa_cliente` (conservando el mismo `token`) y por último `analitica.clientes`.
5. **Validar:** conteos, integridad referencial y muestreo de registros; documentar el incidente.

No se restauran registros que sí debían eliminarse.

---

## 19.6 Conclusiones

### ¿Qué técnica utilizaría para un área de soporte?

**Enmascaramiento mediante una vista con rol restringido.** Soporte necesita identificar y atender al cliente, no ver todos sus datos. La vista `v_clientes_soporte` muestra solo fragmentos útiles para verificar identidad, y el rol `soporte` no tiene acceso a la tabla base. Convendría revisar si realmente necesita el `nombre` completo y reforzar con auditoría de accesos.

### ¿Qué técnica utilizaría para un área de analítica?

**Seudonimización con separación de esquemas y permisos.** El analista trabaja con `analitica.clientes` (token y atributos), puede seguir a un mismo cliente a lo largo del tiempo, pero no tiene acceso a `pii.mapa_cliente` ni a la tabla original. Como los cuasi-identificadores siguen presentes, conviene **generalizarlos** (rangos de edad, código postal truncado, año de alta) para reducir el riesgo.

### ¿Qué técnica utilizaría para publicar estadísticas?

**Anonimización con agregación, generalización y supresión de grupos pequeños** (k-anonimato con un umbral como k ≥ 5, y supresión complementaria cuando se publiquen totales). Para mayor protección, considerar privacidad diferencial. Solo debe publicarse si el volumen de datos lo permite: con 5 registros, todo se suprime.

### ¿Por qué ninguna de estas técnicas sustituye al control de acceso?

- Los datos originales **siguen existiendo** en la tabla base, y quien acceda a ella ve todo.
- El enmascaramiento solo funciona si el usuario **no puede saltarse la vista** consultando la tabla; por eso se revocó el acceso a `clientes`.
- La seudonimización solo es efectiva si **nadie no autorizado** accede al mapa.
- La anonimización es difícil de garantizar y puede ser vulnerada por cruce con información externa.
- Las técnicas reducen el riesgo de **lo que se muestra**; el control de acceso determina **quién puede llegar a los datos**. Son capas complementarias (defensa en profundidad), y la seguridad no debe depender de un único control.

---

## 20. Preguntas de reflexión

### 1. ¿Cuál es la diferencia entre enmascaramiento y seudonimización?

El **enmascaramiento** oculta u ofusca parte del valor para su visualización (por ejemplo `******4567`); el dato sigue siendo reconocible en parte y el original permanece en la tabla. La **seudonimización** sustituye el identificador por un token y guarda la correspondencia en un lugar separado; el dato se desliga de la persona salvo que se use el mapa. El primero protege la **visualización**, la segunda la **vinculación** con la identidad.

### 2. ¿Por qué la seudonimización no significa anonimización?

Porque existe una forma de revertirla (el mapa `token` ↔ `cliente_id`), de modo que la persona sigue siendo identificable con información adicional. Además, los cuasi-identificadores que permanecen pueden reidentificar sin usar el mapa. Los datos seudonimizados siguen siendo datos personales; solo la anonimización irreversible los saca del ámbito de la protección de datos.

### 3. ¿Por qué eliminar `nombre` y `RFC` no garantiza que un conjunto de datos sea anónimo?

Porque quedan **correo, teléfono, id** (que también identifican) y los **cuasi-identificadores** (`edad`, `ciudad`, `codigo_postal`, `fecha_alta`). Su combinación puede aislar a una persona, sobre todo en muestras pequeñas: en este ejemplo cada combinación de `codigo_postal` y `edad` es única. Además, la tabla original sigue existiendo y permite revertir el proceso.

### 4. ¿Qué función tienen los cuasi-identificadores?

Son atributos que no identifican a una persona por sí solos, pero que **combinados entre sí o con fuentes externas** permiten reducir el grupo de candidatos hasta singularizarla. Son la base de los ataques de reidentificación y de técnicas como el k-anonimato, que buscan controlar cuántas personas comparten la misma combinación.

### 5. ¿Por qué es importante separar el mapa de seudonimización?

Porque el mapa es la **llave** que revierte el proceso. Si está junto a los datos analíticos o accesible para quien los analiza, la seudonimización pierde todo valor. Separarlo en otro esquema (`pii`), con permisos propios, rol de custodia y auditoría, evita que un solo acceso comprometido permita reidentificar a todos los clientes.

### 6. ¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?

Principalmente **mínimo privilegio** (solo recibe lo necesario para su función) y **separación de funciones** (quien analiza no es quien puede reidentificar). También **defensa en profundidad**, **minimización de datos** y **protección de datos desde el diseño**.

### 7. ¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?

Porque la vista **limita columnas y transforma valores** antes de entregarlos, y el usuario no necesita ningún permiso sobre la tabla base: en la práctica, `soporte` consulta `v_clientes_soporte` pero recibe `permission denied` al consultar `clientes`. Permite aplicar mínimo privilegio, centralizar la regla de enmascaramiento en la base de datos (no en la aplicación) y cambiarla sin modificar los permisos. Con acceso directo, el enmascaramiento sería decorativo: el usuario podría consultar los datos completos.

### 8. ¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?

Proteger para **visualización** controla **cómo se ve** el dato (máscaras, generalización), pero el valor original puede seguir existiendo y ser accesible por otras vías. Proteger contra **acceso no autorizado** controla **quién puede llegar** al dato (permisos, roles, cifrado, autenticación, auditoría). Lo primero reduce la exposición accidental o innecesaria; lo segundo impide que el dato sea obtenido por quien no debe. Se necesitan ambos.

### 9. ¿Por qué la retención forma parte de la protección de datos?

Porque los principios de **finalidad y proporcionalidad** exigen conservar los datos solo mientras sean necesarios. Un dato que ya no existe no puede filtrarse, usarse indebidamente ni ser objeto de un acceso no autorizado. Una política de retención con aprobaciones, respaldos, evidencia y recuperación ordenada reduce la superficie de riesgo y demuestra responsabilidad ante auditorías.

### 10. ¿Qué riesgo existe si una organización conserva información indefinidamente?

- **Mayor impacto de una brecha:** más datos, más antiguos y de más personas expuestos.
- **Incumplimiento legal:** se trata información sin finalidad vigente, contra los principios de proporcionalidad y finalidad.
- **Datos desactualizados o inexactos**, que pueden causar decisiones erróneas.
- **Mayor costo y complejidad** de almacenamiento, respaldo y control de acceso.
- **Más responsabilidad** ante derechos de cancelación, sanciones y daño reputacional.
- **Uso para fines distintos** a los informados originalmente.
