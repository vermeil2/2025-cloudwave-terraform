# AWS EKS 기반 올리브영 인프라 프로젝트

Terraform을 사용하여 AWS EKS(Elastic Kubernetes Service) 클러스터와 관련 인프라를 코드로 관리하는 Infrastructure as Code(IaC) 디렉토리 입니다.


## 🏗️ 아키텍처

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Cloud                            │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              VPC (Multi-AZ)                      │  │
│  │  ┌──────────────┐      ┌──────────────┐        │  │
│  │  │ Public Subnet│      │ Public Subnet│        │  │
│  │  │   Zone 1     │      │   Zone 2     │        │  │
│  │  └──────────────┘      └──────────────┘        │  │
│  │  ┌──────────────┐      ┌──────────────┐        │  │
│  │  │Private Subnet│      │Private Subnet│        │  │
│  │  │   Zone 1     │      │   Zone 2     │        │  │
│  │  │              │      │              │        │  │
│  │  │   EKS Nodes  │      │   EKS Nodes  │        │  │
│  │  └──────────────┘      └──────────────┘        │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              EKS Cluster                         │  │
│  │  • Kubernetes Control Plane                      │  │
│  │  • Node Groups (Auto Scaling)                    │  │
│  │  • OIDC Provider (IRSA)                          │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │         Kubernetes Add-ons                       │  │
│  │  • Metrics Server                                │  │
│  │  • Cluster Autoscaler                            │  │
│  │  • AWS Load Balancer Controller                  │  │
│  │  • Prometheus + Grafana (Monitoring)             │  │
│  │  • ArgoCD (GitOps)                               │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## 🚀 주요 기능

### 네트워크 인프라
- **VPC**: 멀티 AZ 고가용성 네트워크 구성
- **서브넷**: Public/Private 서브넷 분리 (각 AZ별)
- **NAT Gateway**: Private 서브넷의 아웃바운드 트래픽 처리
- **Internet Gateway**: Public 서브넷 인터넷 연결

### EKS 클러스터
- **Kubernetes Control Plane**: 관리형 EKS 클러스터
- **Node Groups**: 자동 스케일링 가능한 워커 노드
- **IAM Roles**: 클러스터 및 노드용 IAM 역할 구성
- **OIDC Provider**: IRSA(IAM Roles for Service Accounts) 지원

### Kubernetes Add-ons
- **Metrics Server**: 리소스 메트릭 수집
- **Cluster Autoscaler**: 노드 자동 스케일링
- **AWS Load Balancer Controller**: ALB/NLB 자동 프로비저닝
- **Prometheus + Grafana**: 모니터링 및 대시보드
- **ArgoCD**: GitOps 기반 배포 자동화

### 보안 및 접근 제어
- **IRSA**: ECR 접근을 위한 IAM Roles for Service Accounts
- **IAM Policies**: 최소 권한 원칙 적용
- **Network Isolation**: Private/Public 서브넷 분리

## 📁 디렉토리 구조

```
terraform-env/
├── main.tf                    # 메인 모듈 구성
├── variables.tf                # 변수 정의
├── output.tf                  # 출력 값 정의
├── provider.tf                # Provider 설정
├── tfbackend.tf               # Terraform Backend 설정
├── README.md                  # 프로젝트 문서
│
├── environments/              # 환경별 설정
│   ├── prod/
│   │   └── terraform.tfvars   # Production 환경 변수
│   ├── staging/
│   │   └── terraform.tfvars   # Staging 환경 변수
│   └── DR/
│       └── terraform.tfvars   # Disaster Recovery 환경 변수
│
└── modules/                   # 재사용 가능한 모듈
    ├── network/               # VPC, Subnet, NAT Gateway
    ├── eks/                   # EKS 클러스터 및 Node Groups
    ├── metric-server/         # Kubernetes Metrics Server
    ├── cluster-autoscaler/    # Cluster Autoscaler
    ├── lb-controller/         # AWS Load Balancer Controller
    ├── monitoring/            # Prometheus + Grafana
    ├── argocd/                # ArgoCD GitOps
    └── ecr-irsa/              # ECR 접근을 위한 IRSA
```

## 🛠️ 기술 스택

- **Infrastructure as Code**: Terraform
- **Cloud Provider**: AWS
- **Container Orchestration**: Amazon EKS (Kubernetes)
- **Package Management**: Helm
- **Monitoring**: Prometheus, Grafana
- **CI/CD**: ArgoCD (GitOps)
- **Backend**: Terraform S3 Backend

## 📦 모듈 상세

### network
VPC, 서브넷, 라우팅 테이블, NAT Gateway, Internet Gateway를 구성합니다.

### eks
EKS 클러스터, Node Groups, IAM 역할 및 정책을 생성합니다.

### metric-server
Kubernetes Metrics Server를 배포하여 리소스 메트릭을 수집합니다.

### cluster-autoscaler
워크로드에 따라 노드를 자동으로 스케일링합니다.

### lb-controller
Kubernetes Ingress 리소스를 기반으로 AWS ALB/NLB를 자동 생성합니다.

### monitoring
Prometheus와 Grafana를 배포하여 클러스터 및 애플리케이션 모니터링을 제공합니다.

### argocd
GitOps 기반으로 애플리케이션 배포를 자동화합니다.

### ecr-irsa
ECR 이미지 접근을 위한 IAM Roles for Service Accounts를 구성합니다.

## 🚦 시작하기

### 사전 요구사항

- AWS CLI 설치 및 구성
- Terraform >= 1.0
- kubectl 설치
- Helm 3.x 설치
- 적절한 AWS 권한 (IAM, EC2, EKS, VPC 등)

### 사용 방법

1. **Terraform 초기화**
   ```bash
   terraform init
   ```

2. **환경 선택 및 변수 파일 설정**
   ```bash
   # Staging 환경
   terraform workspace select staging
   terraform plan -var-file=./environments/staging/terraform.tfvars
   terraform apply -var-file=./environments/staging/terraform.tfvars
   
   # Production 환경
   terraform workspace select prod
   terraform plan -var-file=./environments/prod/terraform.tfvars
   terraform apply -var-file=./environments/prod/terraform.tfvars
   ```

3. **Kubernetes 클러스터 연결**
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster-name>
   ```

4. **배포 확인**
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

## ⚙️ 주요 변수

| 변수명 | 설명 | 예시 |
|--------|------|------|
| `env` | 환경 이름 | `prod`, `staging` |
| `region` | AWS 리전 | `ap-northeast-2` |
| `eks_name` | EKS 클러스터 이름 | `my-eks-cluster` |
| `eks_version` | Kubernetes 버전 | `1.31` |
| `instance_types` | 노드 인스턴스 타입 | `t3.large` |
| `zone1`, `zone2` | 가용 영역 | `ap-northeast-2a`, `ap-northeast-2c` |
| `private_zone1_cidr` | Private 서브넷 CIDR (Zone 1) | `10.1.16.0/20` |
| `public_zone1_cidr` | Public 서브넷 CIDR (Zone 1) | `10.1.144.0/20` |

## 🔒 보안 고려사항

- 모든 민감한 정보는 변수로 관리하며 `.tfvars` 파일은 버전 관리에서 제외
- IAM 정책은 최소 권한 원칙 적용
- Private 서브넷에 워커 노드 배치
- OIDC 기반 IRSA를 통한 서비스 계정 권한 관리

## 📝 주의사항

- **Terraform Destroy 시**: 로드밸런서가 생성된 경우, 네트워크 인터페이스(ENI)가 자동으로 삭제되지 않을 수 있습니다. 수동으로 EC2 콘솔에서 로드밸런서를 먼저 삭제한 후 destroy를 실행하세요.
- **Helm 의존성**: `prometheus_stack` 관련 에러가 발생하면 종속성 문제일 수 있으므로 다시 apply를 시도하세요.
