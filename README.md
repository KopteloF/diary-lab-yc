# diary-lab-yc

OpenTofu для учебного стенда diary-lab в Yandex Cloud: VPC, подсети, security groups, NAT gateway, три VM (bastion, app, db).

Конфигурация ОС и приложения: репозиторий [diary-lab](https://github.com/KopteloF/diary-lab) (Ansible).

Секреты, state и реальные `terraform.tfvars` в git не хранятся.

## Что поднимает

- сеть и подсети
- NAT gateway для машин без публичного IP
- security groups (SSH на bastion с твоего CIDR, доступ app/db с bastion, Postgres с app)
- VM: bastion (с публичным IP), app, db

## Быстрый старт

```bash
cp terraform.tfvars.example terraform.tfvars
# cloud_id, folder_id, my_ssh_cidr, путь к ключу SA и т.д.

tofu init
tofu plan
tofu apply
tofu output
```

После смены VPN обнови `my_ssh_cidr` и снова `tofu apply` (обычно только SG).

## CI

GitHub Actions: `tofu fmt -check -recursive` на push/PR в `master`.  
Полный `validate`/`apply` в CI не гоняется: нужен ключ SA и параметры облака.

## После apply

Возьми `tofu output` (публичный IP bastion, внутренние IP app/db) и пропиши их в inventory/ssh config репозитория diary-lab. Отдельный шаг, не часть `tofu apply`.

## Важно

- Публичный IP bastion нужен для твоего SSH.
- NAT gateway нужен, чтобы app/db ходили в интернет без своих белых IP.
- Это разные механизмы; bastion в YC не заменяет NAT gateway как в домашнем VirtualBox-роутере.

## Уничтожение стенда

```bash
tofu destroy
```

Проверь биллинг: диски, IP, NAT, если что-то осталось после destroy.
