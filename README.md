# Dailyge Infra


## 패키지 구조

```shell
├─ README.md
├─ main.tf
├─ 📁modules                  # Modules
│       ├─📁 cloudfront       # Resource
│       │    └── ......
│       ├─📁 s3
│       │    └── ......
│       └─📁 vpc
│           ├─ main.tf        # main.tf
│           ├─ output.tf      # output.tf
│           └─ variables.tf   # variables.tf
├── provider.tf
└── variables.tf
```
