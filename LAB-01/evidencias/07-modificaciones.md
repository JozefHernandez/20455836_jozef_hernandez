# Modificaciones

## 1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?
El nivel que habría registrado la lectura es all que registra todas las sentencias incluidos los SELECT ni ddl ni mod lo hacen. Como alternativa  la extensión pgaudit permite registrar solo las lecturas de ciertas tablas o de ciertos roles sin registrar todo lo demás. El costo en un servidor asi seria abismal por como se suele pagar el servicio que es de pago por uso.

## 2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza?
Le falta el valor anterior, la línea registrada dice que el teléfono se fijó en 6679990000 pero no dice qué contenía antes, y sin ese dato no se puede restaurar el estado original con certeza.