# Argocd Imager Updater Job

## CronJob

- `argocd-image-updater-cronjob.yaml` 파일을 사용하여 CronJob 생성
- CronJob은 주기적으로 실행되며, Argo CD Image Updater를 실행하여 이미지 업데이트를 확인하고 적용합니다.
- CronJob의 스케줄은 `schedule` 필드에서 설정할 수 있으며, 현재는 "0 0 31 12 \*"로 설정되어 있어 12월 31일 0시 0분에 실행되도록 되어 있습니다.
- 수동으로 실행 시 Trigger를 통해 Job을 생성할 수 있으며, 이 Job은 한 번만 실행됩니다.

## Once Job

- 수동으로 실행하고 싶다면 `argocd-image-updater-job.yaml` 파일을 사용하여 Job을 생성할 수 있습니다. 이 Job은 한 번만 실행되며, 이미지 업데이트를 확인하고 적용합니다.
- 다시 실행하고 싶다면 Job을 삭제 후 재생성해야 합니다.
