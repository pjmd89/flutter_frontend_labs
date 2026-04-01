# Configuración de Login con Mailcow

## Resumen
Se ha implementado el login con Mailcow siguiendo exactamente el mismo patrón que el login con Google.

## Archivos Modificados

### 1. `/lib/src/infraestructure/config/env.dart`
- Agregado getter `backendMailcowAuthUrl` para obtener la URL del endpoint de autenticación Mailcow según la plataforma

### 2. `/lib/src/presentation/pages/Login/read/main.dart`
- Agregado método `_startMailcowLogin()` (copia exacta del flujo de Google)
- Agregado botón "Continuar con Mailcow"
- Actualizado título de la página a "Inicia sesión" (genérico para ambos métodos)

### 3. `/assets/images/mailcow.svg`
- Creado logo SVG simple de Mailcow (ícono de sobre/email)

## Variables de Entorno Requeridas

### Para compilaciones Web
Agregar en tu comando de compilación o archivo de configuración:

```bash
flutter build web --dart-define=webMailcowAuthURL=https://tu-backend.com/auth-request
```

### Para compilaciones Mobile (Android/iOS)
```bash
flutter build apk --dart-define=mobileMailcowAuthURL=https://tu-backend.com/auth-request
```

### Para compilaciones Desktop (Linux/macOS/Windows)
```bash
flutter build linux --dart-define=desktopMailcowAuthURL=https://tu-backend.com/auth-request
```

### Ejemplo completo para desarrollo web:
```bash
flutter run -d chrome \
  --dart-define=env=dev \
  --dart-define=webApiURL=https://api.ejemplo.com/graphql \
  --dart-define=webAuthURL=https://api.ejemplo.com/auth/google \
  --dart-define=webMailcowAuthURL=https://api.ejemplo.com/auth-request \
  --dart-define=webAuthCallbackPath=/auth/callback
```

## Configuración del Backend

El backend debe implementar el endpoint `/auth-request` (o el que configures) con el siguiente comportamiento:

### Endpoint: `GET /auth-request`

**Query Parameters esperados del frontend:**
- `redirect_uri`: URL a donde redirigir después de la autenticación exitosa
- `state`: Token CSRF generado por el frontend

**Configuración de Mailcow en el backend:**
```json
{
  "client_id": "4b6156a0a154",
  "client_secret": "5f09d464abb074816e71f88e",
  "redirect_url": "https://localhost:8443/auth/mailcow/callback",
  "auth_url": "https://mail.allsoftwaretech.com/oauth/authorize",
  "token_url": "https://mail.allsoftwaretech.com/oauth/token",
  "resource_page": "https://mail.allsoftwaretech.com/oauth/profile"
}
```

**Flujo esperado:**

1. Frontend → `GET /auth-request?redirect_uri=...&state=...`
2. Backend redirige a → Mailcow OAuth (`auth_url`)
3. Usuario se autentica en Mailcow
4. Mailcow redirige a → Backend callback (`redirect_url`)
5. Backend valida con Mailcow (`token_url` y `resource_page`)
6. Backend crea/actualiza usuario en DB
7. Backend establece cookie de sesión
8. Backend redirige a → Frontend (`redirect_uri` original + parámetro `state`)
9. Frontend valida el `state` y llama a `getLoggedUser`
10. ViewModel obtiene el usuario autenticado y completa el login

## Componentes Reutilizados

El flujo de Mailcow reutiliza **100%** de la infraestructura existente de Google:

- ✅ `AuthCallbackPage` - Sin cambios necesarios
- ✅ `ViewModel` con `loggedUser()` y `setLoginUser()` - Sin cambios
- ✅ Sistema de OAuth state (CSRF protection) - Mismo código
- ✅ Helpers de redirección web - Mismo código
- ✅ Manejo de cookies y sesiones - Mismo código

## Personalización del Logo

Si deseas usar el logo oficial de Mailcow:

1. Descarga el logo desde: https://mailcow.email/
2. Conviértelo a SVG (si no lo está)
3. Reemplaza `/assets/images/mailcow.svg`
4. Ejecuta `flutter pub get` para registrar el nuevo asset

## Testing

### Verificar que las variables están configuradas:
```dart
print(Environment.backendMailcowAuthUrl); // Debe mostrar tu URL
```

### Flujo de testing:
1. Hacer clic en "Continuar con Mailcow"
2. Debe redirigir a tu backend (`/auth-request`)
3. Backend debe redirigir a Mailcow OAuth
4. Después de autenticarse, debe volver al frontend
5. Debe mostrar "Validando credenciales…"
6. Debe completar el login y redirigir a `/home`

## Notas Importantes

- 🔒 El parámetro `state` es **obligatorio** para seguridad (protección CSRF)
- 🍪 El backend **debe** configurar cookies con `httpOnly`, `secure`, y `sameSite`
- 🔄 El `redirect_uri` se construye automáticamente según `webAuthCallbackPath`
- ⚠️ Solo funciona en compilaciones **web** (no en mobile/desktop sin configuración adicional)
- 📱 Para mobile/desktop, necesitarás implementar deep linking o usar webview

## Troubleshooting

### Error: "Debe configurarse la variable webMailcowAuthURL..."
**Solución:** Agregar `--dart-define=webMailcowAuthURL=...` al comando de compilación/ejecución

### Error: El botón no hace nada
**Solución:** Verificar que estás en una compilación web (`kIsWeb == true`)

### Error: Redirección fallida
**Solución:** Verificar que el backend esté configurado correctamente y accesible

### Error: "Error al validar las credenciales"
**Solución:** Verificar que:
1. El backend esté configurando correctamente la cookie de sesión
2. El dominio de la cookie coincida con el dominio del frontend
3. El backend esté retornando el parámetro `state` en la redirección

## Próximos Pasos

Si necesitas más proveedores OAuth (GitHub, Microsoft, etc.), simplemente replica este patrón:

1. Crear logo SVG en `/assets/images/{provider}.svg`
2. Agregar getter en `Environment` para `backend{Provider}AuthUrl`
3. Agregar método `_start{Provider}Login()` en `LoginPage`
4. Agregar botón en la UI
5. Configurar variables de entorno
6. El backend implementa `/auth/{provider}` siguiendo el mismo patrón

---

**Implementado:** 1 de abril de 2026
**Patrón base:** Login con Google OAuth
**Compatibilidad:** 100% con infraestructura existente
