### 프로젝트 개요

**‘올리브영 O2O 서비스, 고객 경험을 혁신하는 인프라 설계’ 프로젝트**는 온·오프라인 사용자 경험의 격차를 줄이고, 더욱 **실시간성**, **확장성**, **고가용성**을 갖춘 인프라를 구축하는 것을 목표로 했습니다. 

### 프로젝트 추진 배경

O2O(Online to Offline) 서비스는 온라인 플랫폼을 통해 오프라인 서비스를 예약하거나 주문할 수 있는 구조로, 최근 유통 업계에서 필수적인 서비스로 자리 잡았습니다. 특히 올리브영은 국내 대표적인 H&B(Health & Beauty) 브랜드로, 오프라인 매장을 기반으로 앱을 통한 주문 및 픽업 서비스를 제공하고 있습니다.

하지만 실제 현장을 방문한 결과, 다음과 같은 문제점들이 발견되었습니다

- **재고 차감 시점의 불일치**로 인해 앱 주문 고객과 현장 고객 간 재고 충돌이 발생함
- 실시간 재고 반영이 되지 않아 **주문 후 품절 통보**를 받는 경우가 빈번함
- 매장 직원은 주문 처리로 인해 업무가 과중되고, 고객 응대의 질이 저하됨
- 고객 입장에서도 매장 재고 확인과 상품 확보에 대한 **불신**이 존재함

**위의 문제를 해결하고, 고가용성 서비스를 제공하기 위해 AWS 클라우드 플랫폼과 컨테이너 기반 아키텍처(EKS)**를 선택하고, 인프라 자동화, 보안, 모니터링 등을 종합적으로 고려하였습니다.

## 웹 시연

![웹시연](웹_시연.gif)

## 아키텍처

![아키텍처](https://github.com/vermeil2/2025-cloudwave-terraform/blob/main/%EC%9D%B8%ED%94%84%EB%9D%BC%20%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98.png)

## **아키텍처 설계**

### 전체 아키텍처 개요

본 프로젝트는 **실시간성, 확장성, 고가용성**을 달성하기 위해 **EKS 기반의 마이크로서비스 아키텍처**를 도입했습니다. 운영 환경은 **Seoul 리전을 기준으로 구성**되며, **Tokyo 리전은 재해 복구(DR, Disaster Recovery)** 용도로 구성되어 있습니다.

- **클라이언트 접근 경로**: Route53, WAF, CloudFront, ACM을 통해 안전하게 라우팅
- **서비스 운영 환경**: 서울 리전의 Amazon EKS에서 컨테이너 기반으로 서비스 운영
- **재해복구 환경**: 도쿄 리전에 이중화된 EKS, DB 환경 구성
- **실시간 처리 기반**: Redis + Kafka 조합으로 빠르고 확장 가능한 데이터 처리
- **모니터링 및 로깅**: Grafana, Prometheus, CloudWatch, Athena 등 도입
- **배포 자동화**: GitLab → Jenkins → ECR → ArgoCD 기반의 GitOps 파이프라인 운영

## 주요 기능

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

## 기술 스택

- **Infrastructure as Code**: Terraform
- **Cloud Provider**: AWS
- **Container Orchestration**: Amazon EKS (Kubernetes)
- **Package Management**: Helm
- **Monitoring**: Prometheus, Grafana
- **CI/CD**: ArgoCD (GitOps)
- **Backend**: Terraform S3 Backend

## 사전 준비

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

| 변수명 | 설명 | 내용 |
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

- **Terraform Destroy 시**: 로드밸런서가 생성된 경우, 네트워크 인터페이스(ENI)가 자동으로 삭제되지 않을 수 있습니다. 수동으로 EC2 콘솔에서 로드밸런서를 먼저 삭제한 후 destroy를 실행하세요. 또한, S3 삭제시 버킷 내용을 비우지 않으면 삭제되지 않으니 주의하세요.
