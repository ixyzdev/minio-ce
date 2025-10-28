# **MinIO Container Stack** 🚀

## 📋 **Descripción**
Despliegue containerizado de MinIO Community Edition optimizado para entornos privados con proxy reverso. Una solución de almacenamiento de objetos compatible con S3, diseñada para ser simple, segura y auto-contenida.

## 🎯 **Propósito**
Este proyecto implementa MinIO como servicio contenerizado con configuración production-ready, incluyendo verificaciones de salud, SSL via proxy reverso y prácticas de seguridad modernas.

## 🏗️ **Arquitectura**
- **Imagen Base**: `minio/minio:RELEASE.2024-12-18T22-07-25Z`
- **Orquestación**: Docker Compose
- **Proxy**: Nginx Proxy Manager (red externa)
- **Persistencia**: Volumen Docker named volume
- **Health Checks**: Verificaciones de readiness/liveness

## ⚙️ **Configuración Rápida**

### **Prerrequisitos**
```bash
docker compose
nginx-proxy-manager (red externa)
```

### **Despliegue**
1. **Clonar y configurar**:
```bash
git clone <este-repositorio>
cd minio-ce
cp .env.example .env
# Editar .env con tus valores
```

2. **Variables de entorno** (.env):
```bash
MINIO_ROOT_USER=tu_usuario
MINIO_ROOT_PASSWORD=tu_password_seguro
MINIO_REGION=us-east-1
MINIO_SERVER_URL=https://s3.tudominio.com
MINIO_BROWSER_REDIRECT_URL=https://console.tudominio.com
```

3. **Ejecutar**:
```bash
docker compose up -d
```

## 🌐 **URLs del Sistema**
- **API S3**: `https://s3.tudominio.com` (puerto 9000)
- **Consola Web**: `https://console.tudominio.com` (puerto 9001)
- **Health Check**: `http://localhost:9000/minio/health/ready`

## 🔗 **Enlaces Oficiales**
- **Código Fuente**: https://github.com/minio/minio
- **Binarios**: https://dl.min.io/server/minio/release/
- **Imágenes Docker**: https://hub.docker.com/r/minio/minio

## 🛡️ **Características de Seguridad**
- Verificación de health checks automáticos
- Configuración para proxy reverso con SSL
- Variables de entorno para credenciales
- Volúmenes aislados para persistencia
- Restart policy para alta disponibilidad

## 📊 **Monitoreo**
El contenedor incluye health checks que verifican:
- Estado del servicio cada 30s
- Readiness del endpoint S3
- Timeouts configurados para respuestas lentas

## 🗂️ **Estructura**
```
minio-ce/
├── docker-compose.yml    # Orquestación de servicios
├── .env                  # Configuración (no versionado)
└── README.md            # Esta documentación
```

## ⚠️ **Notas Importantes**
- Las credenciales se gestionan via variables de entorno
- La persistencia usa volúmenes Docker named volumes
- Requiere configuración previa de nginx-proxy-manager
- Región configurada como `us-east-1` por compatibilidad

## 🔄 **Mantenimiento**
- **Actualizaciones**: Cambiar tag en docker-compose.yml
- **Backups**: Scripts de backup no incluidos (ver implementaciones separadas)
- **Logs**: `docker compose logs minio`
