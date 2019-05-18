```
# issued on the jumpbox VM
# flags
## -X -- stop the execution if error occurs
docker run -t \
  -v ${HOME}/.ssh:/root/.ssh \
  -v /home/admin/nuagex-labs/0890-VNS-EXFO_WORX-1/cats:/home/tests \
  nuagepartnerprogram/cats:5.4.1 \
    -X /home/tests
```