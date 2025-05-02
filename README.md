# EKS Practice Infrastructure (with Terraform)

본 프로젝트는 **AWS EKS 클러스터를 Terraform으로 자동화**하고, `kubectl` CLI를 통해 Kubernetes 자원을 제어할 수 있도록 구성된 실습 환경입니다.
Update 중

## 📁 프로젝트 구조

```
eks-practice/
├── main.tf                    # VPC, EKS 클러스터, 노드 그룹 정의
├── provider.tf               # AWS & Kubernetes Provider 설정
├── variables.tf              # 변수 선언
├── terraform.tfvars          # 실질적인 값 정의 (ex. region, cluster_name)
├── outputs.tf                # 출력 변수
├── aws-auth_configmap.tf     # aws-auth ConfigMap 매핑 (eks-admin 권한)
├── aws-auth.yaml             # 수동으로 적용할 수 있는 yaml 포맷 (옵션)
└── README.md
```

---

## ⚙️ 구성 요소

| 항목              | 설명 |
|------------------|------|
| **VPC**          | 퍼블릭/프라이빗 서브넷, NAT Gateway, IGW 등 포함 |
| **EKS Cluster**  | 1.30 버전의 AWS EKS 클러스터 |
| **Node Group**   | `t3.medium` 타입의 관리형 노드 그룹 |
| **IAM Role**     | IRSA 및 aws-auth 기반의 클러스터 접근 권한 설정 |
| **kubectl**      | EKS 접속을 위한 kubeconfig 자동 구성 |
| **aws-auth**     | `system:masters` 그룹에 사용자 매핑 |

---

## 🚀 배포 방법

### 1) 초기 provider 설정: 클러스터 생성 전

`provider.tf`에서 아래 블록들을 **주석 처리**합니다:

```
data "aws_eks_cluster" "cluster" { ... }
data "aws_eks_cluster_auth" "cluster" { ... }
provider "kubernetes" { ... }
```

### 2) Terraform으로 인프라 생성

```bash
terraform init -upgrade
terraform plan -out=plan.tfplan
terraform apply -auto-approve plan.tfplan
```

### 3) kubeconfig 연결

```bash
aws eks update-kubeconfig   --region ap-northeast-2   --name sungbin-eks

kubectl get nodes
```

### 4) provider 주석 해제 후 `aws-auth` 적용

```bash
# provider.tf의 data & kubernetes provider 블록 주석 해제

terraform apply -auto-approve
```

---

## ✅ 권장 변수 예시 (`terraform.tfvars`)

```hcl
region             = "ap-northeast-2"
cluster_name       = "sungbin-eks"
admin_user_arn     = "arn:aws:iam::123456789012:user/sungbin"
node_group_name    = "default"
node_instance_type = "t3.medium"
node_desired_size  = 2
vpc_cidr           = "10.0.0.0/16"
```

---

## 🧼 삭제

```bash
terraform destroy -auto-approve
```

---

## 🙋‍♂️ 참고 자료

- [Terraform AWS EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
- [Amazon EKS 공식 문서](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Kubernetes RBAC 가이드](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
