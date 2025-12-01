# tf-aws-stockwiz

Infraestructura como Código (IaC) para el despliegue de la aplicación StockWiz en AWS utilizando Terraform. Este repositorio gestiona múltiples capas de infraestructura incluyendo networking, ECR/Lambda y servicios ECS con sus dependencias.

## 📋 Tabla de Contenidos

- [Arquitectura](#arquitectura)
- [Prerequisitos](#prerequisitos)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [CI/CD Pipelines](#cicd-pipelines)
- [Configuración Inicial](#configuración-inicial)
- [Guía de Despliegue](#guía-de-despliegue)
- [Configuración de Variables](#configuración-de-variables)
- [Gestión de Estados](#gestión-de-estados)
- [Ambientes](#ambientes)
- [Recursos Desplegados](#recursos-desplegados)

## 🏗️ Arquitectura

La infraestructura se despliega en tres capas independientes para mejor manejo y modularidad:

1. **Network-Layer**: VPC, subnets, Internet Gateway y tablas de ruteo
2. **ECR-Layer**: Repositorios ECR para imágenes Docker y funcion Lambda
3. **ECS-Layer**: Cluster ECS, servicios, Load Balancer, RDS PostgreSQL y Redis

## 📦 Prerequisitos

Antes de comenzar, asegúrate de tener instalado:

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado con credenciales válidas
- Acceso a una cuenta de AWS con permisos suficientes
- Bucket S3 para almacenar el estado remoto de Terraform

## 📁 Estructura del Proyecto

```
tf-aws-stockwiz/
├── README.md
└── StockWiz/
    ├── Network-Layer/          # Capa de red
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── providers.tf
    │   ├── output.tf
    │   ├── data.tf
    │   ├── main.tfvars
    │   ├── stream.tfvars
    │   └── modules/
    │       ├── VPC/
    │       ├── Internet-Gateway/
    │       └── Route-Table/
    │
    ├── ECR-Layer/              # Capa de repositorios
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── providers.tf
    │   ├── output.tf
    │   ├── data.tf
    │   ├── main.tfvars
    │   ├── stream.tfvars
    │   └── modules/
    │       ├── ECR/
    │       └── Lambda/
    │
    └── ECS-Layer/              # Capa de aplicación
        ├── main.tf
        ├── variables.tf
        ├── providers.tf
        ├── locals.tf
        ├── output.tf
        ├── data.tf
        ├── main.tfvars         # Variables para ambiente Main (prod)
        ├── stream.tfvars       # Variables para ambiente Stream (dev, test)
        ├── backend-main.hcl    # Backend config Main
        ├── backend-stream.hcl  # Backend config Stream
        └── modules/
            ├── ECS/
            ├── Load-Balancer/
            ├── RDS/
            ├── Redis/
            └── Security-Group/
```

## 🔄 CI/CD Pipelines

El repositorio incluye **pipelines automatizados de GitHub Actions** para el despliegue y destrucción de cada capa de infraestructura, implementando prácticas de CI/CD para Terraform.

### Pipelines de Deploy

#### 1. Network Layer Pipeline
- **Workflow**: `.github/workflows/deploy-network-layer.yaml`
- **Trigger**: Push a `main` con cambios en `StockWiz/Network-Layer/**`
- **Ambiente**: Main (Producción)
- **Pasos**:
  - Checkout del código
  - Configuración de credenciales AWS
  - Setup de Terraform
  - `terraform init`
  - `terraform plan --var-file=main.tfvars`
  - `terraform apply -auto-approve --var-file=main.tfvars`

#### 2. ECR Layer Pipeline
- **Workflow**: `.github/workflows/deploy-ecr-layer.yaml`
- **Trigger**: Push a `main` con cambios en `StockWiz/ECR-Layer/**`
- **Ambiente**: Main (Producción)
- **Pasos**: Similares a Network Layer

#### 3. ECS Layer Pipeline
- **Workflow**: `.github/workflows/deploy-ecs-layer.yaml`
- **Trigger**: Push a `main` o `develop` con cambios en `StockWiz/ECS-Layer/**`
- **Ambientes**: 
  - `main` branch → usa `main.tfvars` y `backend-main.hcl`
  - `develop` branch → usa `stream.tfvars` y `backend-stream.hcl`
- **Características**:
  - Selección automática de archivos de configuración según la rama
  - Soporte multi-ambiente (Main/Stream)
  - Backend state configurado dinámicamente

### Pipelines de Destroy

Cada capa tiene su workflow de destrucción correspondiente:

- **Network Layer**: `.github/workflows/destroy-network-layer.yaml`
- **ECR Layer**: `.github/workflows/destroy-ecr-layer.yaml`
- **ECS Layer**: `.github/workflows/destroy-ecs-layer.yaml`

**Características de los pipelines de destrucción**:
- **Trigger manual**: Requieren ejecución manual (`workflow_dispatch`)
- **Confirmación obligatoria**: Input parameter que debe tener el valor exacto `DESTROY`
- **Validación de seguridad**: El pipeline se detiene si no se confirma correctamente
- **ECS Layer**: Permite seleccionar ambiente (main/stream) antes de destruir

### Configuración de Secrets

Para que los pipelines funcionen, debes configurar los siguientes secrets en GitHub:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

**Configuración**: Repository Settings → Secrets and variables → Actions → New repository secret

### Ventajas de los Pipelines

✅ **Automatización**: Deploy automático al hacer push a las ramas principales
✅ **Consistencia**: Mismo proceso de deploy en cada ejecución
✅ **Seguridad**: Credenciales almacenadas de forma segura en GitHub Secrets
✅ **Trazabilidad**: Historial completo de deployments en GitHub Actions
✅ **Multi-ambiente**: Soporte para Main (prod) y Stream (dev, test) con configuraciones separadas
✅ **Protección**: Workflows de destroy requieren confirmación manual explícita

## ⚙️ Configuración Inicial

### 1. Clonar el Repositorio

```bash
git clone https://github.com/RenxDLA/tf-aws-stockwiz.git
cd tf-aws-stockwiz
```

### 2. Configurar AWS CLI

```bash
aws configure
# Ingresa tus credenciales:
# AWS Access Key ID
# AWS Secret Access Key
# Default region (ej: us-east-1)
```

### 3. Crear Bucket S3 para Estado Remoto

```bash
aws s3 mb s3://tfstate-ob290199 --region us-east-1
aws s3api put-bucket-versioning --bucket tfstate-ob290199 --versioning-configuration Status=Enabled
# Como alternativa se puede utilizar otro repositorio terraform o crearlo manualmente
```

## 🚀 Guía de Despliegue

El despliegue debe realizarse **en orden secuencial** debido a las dependencias entre capas:

### Paso 1: Desplegar Network Layer

```bash
cd StockWiz/Network-Layer

# Inicializar Terraform
terraform init

# Revisar el plan de ejecución
terraform plan -var-file=main.tfvars

# Aplicar la configuración
terraform apply -var-file=main.tfvars

# Guardar outputs importantes (VPC ID, Subnet IDs)
terraform output
```

### Paso 2: Desplegar ECR Layer

```bash
cd ../ECR-Layer

# Inicializar Terraform
terraform init

# Revisar el plan
terraform plan -var-file=main.tfvars

# Aplicar la configuración
terraform apply -var-file=main.tfvars

# Guardar el ECR repository URL
terraform output
```

**Importante**: Después de crear los repositorios ECR, debes construir y pushear las imágenes Docker antes de continuar con ECS Layer.

```bash
# Autenticarse en ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build y push de imágenes (desde el directorio del código)
docker build -t stockwiz-product-service ./product-service
docker tag stockwiz-product-service:latest <ecr-url>/stockwiz-product-service:latest
docker push <ecr-url>/stockwiz-product-service:latest

# Repetir para inventory-service y api-gateway
```

### Paso 3: Desplegar ECS Layer

```bash
cd ../ECS-Layer

# Inicializar con backend configuration
terraform init -backend-config=backend-main.hcl

# Revisar el plan
terraform plan -var-file=main.tfvars

# Aplicar la configuración
terraform apply -var-file=main.tfvars

# Obtener el ALB DNS
terraform output alb_dns_name
```

## 🔧 Configuración de Variables

### Network Layer Variables (`main.tfvars`)

```hcl
aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
app_name             = "StockWiz"
```

### ECS Layer Variables (`main.tfvars`)

Variables clave a configurar:

- **environment**: Nombre del ambiente (Main/Stream)
- **environment_to_deploy**: Array de ambientes ["Prod", "Dev"]
- **service_count**: Número de instancias por servicio
- **db_username/db_password**: Credenciales de base de datos (usar Secrets Manager en producción)
- **instance_class**: Tipo de instancia RDS
- **task_***: Configuración de CPU/memoria para cada servicio

## 📊 Gestión de Estados

El estado de Terraform se almacena remotamente en S3 con las siguientes configuraciones:

### Main Environment
```hcl
bucket = "tfstate-ob290199"
key    = "ecs-layer/main/terraform.tfstate"
region = "us-east-1"
```

### Stream Environment
```hcl
bucket = "tfstate-ob290199"
key    = "ecs-layer/stream/terraform.tfstate"
region = "us-east-1"
```

## 🌍 Ambientes

El proyecto soporta dos ambientes independientes:

### Main (Producción)
```bash
terraform plan -var-file=main.tfvars
terraform apply -var-file=main.tfvars
```

### Stream (Develop/Testing)
```bash
terraform plan -var-file=stream.tfvars
terraform apply -var-file=stream.tfvars
```

## 📦 Recursos Desplegados

### Network Layer
- ✅ VPC con CIDR configurable
- ✅ Subnets públicas y privadas en múltiples AZs
- ✅ Internet Gateway
- ✅ Route Tables con asociaciones

### ECR Layer
- ✅ Repositorios ECR para servicios (product, inventory, api-gateway)
- ✅ Funciones Lambda con configuración

### ECS Layer
- ✅ Cluster ECS Fargate
- ✅ Servicios ECS (Product Service, Inventory Service, API Gateway)
- ✅ Application Load Balancer con Target Groups
- ✅ Security Groups configurados
- ✅ RDS PostgreSQL (db.t3.micro)
- ✅ ElastiCache Redis (cache.t3.micro)
- ✅ Health checks configurados

## 🔄 Comandos Útiles

### Ver estado actual
```bash
terraform show
```

### Ver outputs
```bash
terraform output
```

### Destruir infraestructura
```bash
# IMPORTANTE: Destruir en orden inverso
cd StockWiz/ECS-Layer
terraform destroy -var-file=main.tfvars

cd ../ECR-Layer
terraform destroy -var-file=main.tfvars

cd ../Network-Layer
terraform destroy -var-file=main.tfvars
```

### Formatear código Terraform
```bash
terraform fmt -recursive
```

### Validar configuración
```bash
terraform validate
```

## 📝 Notas Importantes

1. **Dependencias**: Las capas deben desplegarse en orden: Network → ECR → ECS
2. **Imágenes Docker**: Construir y pushear imágenes a ECR antes de desplegar ECS Layer
3. **Backend State**: Configurar el backend remoto antes de `terraform init`
4. **Costs**: Los recursos RDS y Redis generan costos continuos
5. **Health Checks**: Los servicios deben exponer un endpoint `/health` que retorne 200
6. **CI/CD**: Los pipelines se ejecutan automáticamente en push a `main` o `develop`, validar cambios localmente primero


