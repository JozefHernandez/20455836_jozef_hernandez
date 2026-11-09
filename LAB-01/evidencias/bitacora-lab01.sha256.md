# Exportar la bitácora como evidencia y proteger su integridad

## 1. Un resumen SHA-256, ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?
No impide nada un hash no protege el archivo: cualquiera con acceso de escritura puede editarlo, borrarlo o reemplazarlo.

## 2. ¿Dónde debería guardarse el hash para que sea útil como control de integridad?
En un lugar que no controle la misma persona o sistema que puede modificar la bitácora un hash guardado al lado del archivo, en el mismo equipo y con los mismos permisos, no protege nada, porque ambos pueden alterarse a la vez.

## 3. La guía NIST SP 800-92 trata la conservación y protección de bitácoras. ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?

Pérdida por fallo o reinstalación: Un fallo de disco, una reinstalación o recreación del servidor (algo habitual con contenedores) destruye la evidencia.
Alteración o borrado por un atacante: Quien comprometa el servidor puede borrar o editar el log para ocultar su actividad. Es precisamente el escenario en el que más se necesita la evidencia.
Indisponibilidad durante un incidente: Si el servidor está caído, saturado o comprometido, no se puede consultar la bitácora justo cuando hace falta.
Exposición de datos sensibles: El log contiene datos personales y puede contener secretos, y en el servidor está sujeto a los permisos del sistema operativo, a menudo más amplios que los de la base de datos.

## 4. Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio
conservar la bitácora 6 meses de forma accesible y, por el valor de la evidencia del laboratorio, mantener la copia exportada y su hash junto con el informe hasta que concluya el curso y el periodo de revisión o apelación de calificaciones.
