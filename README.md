# 🚀 Terraform para DefectDojo en AWS (Spot Instance)

Este repositorio contiene una configuración de Terraform para desplegar **DefectDojo** en una instancia EC2 de tipo **t3.large** (Spot) en la región `eu-west-1` (Irlanda). El despliegue incluye Docker y Docker Compose con persistencia de datos.

---

## 📦 Recursos que se crean

- 🧠 Instancia EC2 Amazon Linux 2 (`t3.large`, spot).
- 🔐 Key Pair para acceso SSH (debe existir localmente).
- 🔒 Security Group con acceso a:
  - `22` SSH
  - `80` HTTP
  - `443` HTTPS
  - `8080` DefectDojo UI
- 🐳 Instalación automática de Docker + Docker Compose.
- 📁 Descarga de `docker-compose.yml` desde [Jose26Madrid/defectdojo](https://github.com/Jose26Madrid/defectdojo).

---

## ⚙️ Requisitos

- [Terraform](https://www.terraform.io/downloads.html)
- Cuenta de AWS con credenciales configuradas
- Llave SSH pública local en `~/.ssh/id_rsa.pub`

---

## 📜 Uso

```bash
# Inicializar Terraform
terraform init

# Previsualizar cambios
terraform plan

# Aplicar la configuración
terraform apply
```

Al finalizar, tendrás acceso a la interfaz de DefectDojo desde:

```
http://<IP_PUBLICA>:8080
```

---

## 🧹 Para destruir los recursos

```bash
terraform destroy
```

---

## 📝 Notas

- Puedes modificar el archivo `docker-compose.yml` directamente en tu repo para personalizar la instalación.
- La instancia es Spot para reducir costos. Puede ser interrumpida por AWS si el precio sube.

---

## 🪪 Autor

José Magariño  
[MIT License](./LICENSE)
