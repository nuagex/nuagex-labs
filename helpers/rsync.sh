# rsync CWD contents without .git folder to the jumpbox at the `/home/admin/nuagex-labs` path.
# path to your priv key should be passed as a first parameter
# jumpbox last octet should be passed as a second parameter
# example: bash scripts/rsync.sh $HOME/.ssh/cats 120
rsync -azP --delete -e "ssh -i ${1} -o StrictHostKeyChecking=no" --exclude=.git ./ admin@124.252.253.${2}:/home/admin/nuagex-labs