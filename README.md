# dsw-inrae-deployment

L'entièreté des [templates DSW](https://guide.ds-wizard.org/en/latest/application/document-templates/index.html)
réalisés pour le déploiement de l'application au sein d'INRAE.

## Scripts

### [`put.sh`](scripts/put.sh)

Utilisé lors du développement du template, le transmet
à DSW et créé un document. 
Ce script va, dans cet ordre :
 - supprimer le document déjà existant (si nécessaire)
 - supprimer le template déjà existant (si nécessaire)
 - envoyer le template au serveur
 - demander la publication du template
 - exporter le projet selon le template fraîchement créé
   (et sauvegarde l'identifiant du document dans [lastDocument](scripts/lastDocument))