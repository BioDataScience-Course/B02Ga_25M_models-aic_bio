# Instruction concernant la sauvegarde des données localement

Une copie de vos données brutes doit être placée dans le dossier `data/cache/`. Le contenu de ce dossier ne sera pas repris dans le versioning de git et GitHub. Pour se faire, vous utiliserez la fonction de `SciViews::R()`

```
read$type("url_vers_les_données", cache_file = here::here("data", "cache", "data.type"))
```

En prenant bien soin de remplacer "type" aux deux endroits par l'extension du fichier en fonction de son format (par exemple, 'csv' ou 'xlsx'), et en remplaçant "url_vers_les_données" par le lien http ou https ou ftp qui permet de télécharger directement ces données. Cette fonction est utilisée partout pour se référer aux données.

Dans le cas où les données ne seraient PAS téléchargeables directement, et à condition que le fichier les contenant ne fasse pas plus de 2Mo, vous placerez une copie de ces données dans le sous-dossier `data/` manuellement (pas dans `data/cache/` !), et vous expliquerez dans le rapport pour quelles raisons les données ne sont pas accessibles directement par lien URL. Vous les chargerez alors normalement à l'aide de `read()` comme vous en avez l'habitude.
