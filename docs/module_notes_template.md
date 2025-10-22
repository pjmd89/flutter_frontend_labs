# Plantilla de notas por módulo
**Objetivo del documento**: Proporcionar una descripción clara y concisa de cada módulo del sistema, específicamente para los propietarios. Se destaca el propósito de cada módulo, sus funcionalidades principales y la forma en que se integran dentro del ecosistema de la aplicación.

## Company (Compañías)
- **Objetivo**: Gestión de compañías propietarias de los laboratorios.
- **Descripción**: Este módulo permite crear, consultar, actualizar y eliminar compañías en el sistema, además de administrar la información asociada.
	Los propietarios de laboratorios pueden registrar y gestionar múltiples laboratorios bajo una misma compañía, así como mantener al día la información fiscal y los indicadores de productividad de cada uno.


## EvaluationPackage (Resultado de Exámenes)
- **Objetivo**: Control de paquetes de evaluación que agrupan resultados de exámenes.
- **Descripción**: Este módulo habilita la creación, lectura, actualización y eliminación de los paquetes que agrupan los resultados de los exámenes practicados a los pacientes. Por ejemplo, una factura puede vincularse a varios exámenes realizados durante una misma visita al laboratorio. Así se simplifica el seguimiento y la organización de los resultados clínicos asociados a cada paciente.

## Exam (Exámenes)
- **Objetivo**: Administración de exámenes clínicos ofertados.
- **Descripción**: Este módulo permite crear, consultar, actualizar y eliminar exámenes clínicos, además de gestionar sus datos relacionados. Los propietarios pueden definir el precio de cada examen y asociarlo a los laboratorios correspondientes según su oferta de servicios.

## Invoice (Facturación)
- **Objetivo**: Gestionar facturas vinculadas a pacientes y paquetes de evaluación.
- **Descripción**: Este módulo permite crear, consultar, actualizar y anular facturas, además de administrar la información relevante. Cada factura puede incluir múltiples exámenes y vincularse a un paciente específico, lo que facilita la gestión de cobros y pagos en el laboratorio.

## Laboratory (Laboratorios)
- **Objetivo**: Administración de laboratorios físicos.
- **Descripción**: Este módulo permite a los propietarios crear, consultar, actualizar y eliminar laboratorios, así como gestionar la información asociada. Cada laboratorio puede vincularse a una compañía y contar con múltiples empleados, lo que facilita la organización y administración de los recursos disponibles.

## Patient (Pacientes)
- **Objetivo**: Gestión de pacientes atendidos en los laboratorios.
- **Descripción**: Este módulo permite crear, consultar, actualizar y eliminar pacientes, además de administrar sus datos asociados. Cada paciente puede vincularse a un laboratorio específico y tener múltiples exámenes y facturas relacionadas.

## User (Usuarios)
- **Objetivo**: Administración de usuarios del sistema.
- **Descripción**: Este módulo permite crear, consultar, actualizar y eliminar usuarios, además de gestionar la información vinculada a cada uno. Cada usuario puede tener un rol específico (por ejemplo, técnico o facturación) y asociarse a una compañía y/o laboratorio.

---
### Notas transversales
- **Autenticación y autorización**: Todos los módulos dependen del sistema de autenticación para garantizar que solo los usuarios autorizados puedan acceder y modificar la información. La autenticación se gestiona a través del inicio de sesión centralizado con Google; por lo tanto, cada usuario necesita una cuenta de Gmail válida para ingresar a la plataforma.
- **Notificaciones y alertas**: Cuando los técnicos laboratoristas completen los resultados de todos los exámenes asociados a una factura, se enviará una notificación por correo electrónico y mensaje de texto al paciente para informarle que los resultados están disponibles. Cada SMS incluirá un enlace directo a la plataforma web para descargar el PDF con los resultados, mientras que el correo adjuntará el documento correspondiente.
- **Validez de los resultados**: Los archivos PDF incluirán un código QR único que permitirá verificar la autenticidad de los resultados. Dicho código estará vinculado a la base de datos del laboratorio, lo que facilita confirmar que los resultados no han sido modificados y conservan validez oficial.