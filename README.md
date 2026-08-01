# DNS Latency & Capabilities Checker

Un script ligero en **Bash** para auditar y comparar el rendimiento, disponibilidad y características de seguridad (DoT / DoH) de los principales proveedores DNS públicos e ISP en España.

## 📄 Descripción

El script realiza consultas DNS directas sobre una lista configurable de resolvers públicos (Cloudflare, Google, Quad9, AdGuard, OpenDNS) y servidores DNS locales de operadoras (Telefónica/Movistar, Vodafone, Orange). 

Genera una tabla en formato **Markdown** lista para pegar en documentación, informes o directamente en el portal de GitHub.

### Características
- **Medición de latencia en milisegundos:** Mide el tiempo de respuesta real (`Query time`) de la consulta DNS en puerto 53 UDP.
- **Detección en vivo de DoT (DNS over TLS):** Utiliza `netcat` para verificar si el servidor tiene abierto el puerto `853/TCP`.
- **Información de DoH (DNS over HTTPS):** Indica la compatibilidad estándar de cada proveedor.
- **Estado de la consulta:** Refleja la respuesta del servidor (`NOERROR`, `NXDOMAIN`, `TIMEOUT`, `ERROR`).
- **Formato Markdown limpio:** Salida en tabla bien estructurada.

---

## 📋 Requisitos Previos

Asegúrate de tener instalados los siguientes paquetes en tu sistema:

- **`bind` / `bind-utils`**: Proporciona el comando `dig`.
- **`gnu-netcat` / `openbsd-netcat`**: Proporciona el comando `nc`.
- **`gawk`** y **`coreutils`**: (`grep`, `awk`, `tr`).

### Instalación de dependencias por distribución

* **Arch Linux / Manjaro:**
  ```bash
  sudo pacman -S bind openbsd-netcat gawk coreutils
* **Debian / Ubuntu**
  ```bash
  sudo apt update && sudo apt install dnsutils netcat-openbsd gawk coreutils
* **Fedora / RHEL**
  ```bash
  sudo dnf install bind-utils nc gawk coreutils
