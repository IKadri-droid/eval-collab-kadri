# ADR-0001 : Utiliser Traefik comme reverse proxy

- **Statut** : Accepté
- **Date** : 2026-10-06
- **Décideurs** : équipe Infra

## Contexte

L'équipe héberge une quinzaine de services en conteneurs Docker répartis sur deux serveurs (`srv-01`, `srv-02`), derrière un reverse proxy. Aujourd'hui c'est Nginx, configuré à la main (un fichier par service dans `nginx/conf.d/`).

Contraintes :

- De nouveaux services sont ajoutés **chaque mois** : chaque ajout demande d'écrire un virtual host, de recharger Nginx et de produire un certificat.
- Le renouvellement des certificats TLS est **manuel** (certbot tous les 90 jours) et un oubli a **déjà provoqué une coupure** de service.
- L'équipe **maîtrise bien Nginx**, mais **ne connaît pas Traefik**.

## Options envisagées

1. **Nginx** (existant), en automatisant le renouvellement avec certbot (timer systemd + reload).
2. **Traefik v3**, configuré par labels Docker, avec ACME (Let's Encrypt) intégré.

| Critère | Nginx + certbot | Traefik v3 |
| --- | --- | --- |
| Ajout d'un service | Fichier de conf + reload, à la main | Quelques labels dans le compose, découverte automatique |
| Certificats TLS | Outil externe (certbot) à automatiser et superviser | Obtention et renouvellement automatiques intégrés |
| Compétences de l'équipe | Déjà acquises | À acquérir (formation) |
| Performances, maturité | Très éprouvé | Suffisant pour 15 services, éprouvé en contexte Docker |

## Décision

Nous adoptons **Traefik v3** comme reverse proxy sur les deux serveurs, avec la découverte des services par labels Docker et la gestion automatique des certificats Let's Encrypt. La migration se fait service par service, Nginx restant en place jusqu'à la bascule du dernier service.

## Conséquences

### Positives

- Plus de renouvellement manuel des certificats : supprime la cause de la coupure passée.
- Ajouter un service ne demande plus que des labels dans son `docker-compose.yml`, relus en PR avec le reste.
- Tableau de bord et métriques Prometheus intégrés pour la supervision (Grafana).

### Négatives / risques

- L'équipe ne connaît pas Traefik : temps de formation et risque d'erreurs au début. Mitigation : formation, migration progressive en commençant par un service peu critique, runbook dédié.
- Traefik lit le socket Docker : surface d'attaque à limiter (accès en lecture seule ou via un proxy du socket).
- La configuration est répartie dans les labels des services : moins lisible qu'un fichier Nginx centralisé, conventions de nommage à documenter.
- Période de double maintenance Nginx / Traefik pendant la migration.

## Alternatives rejetées

- **Nginx + certbot automatisé** : règle le problème des certificats et garde les compétences de l'équipe, mais chaque nouveau service mensuel reste une configuration manuelle (source d'erreurs), et l'automatisation certbot ajoute un composant de plus à superviser. Option à reconsidérer si la migration vers Traefik échoue.
