#!/bin/bash
curl -X DELETE 'http://localhost:9200/_all'
curl -X POST "localhost:9200/_snapshot/my_nuage_backup/snapshot-number-one/_restore"