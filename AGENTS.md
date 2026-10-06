# AGENTS.md

Consignes pour les agents IA qui travaillent sur ce dépôt. L'humain qui pousse, approuve ou merge reste responsable de chaque changement.

## Contexte du projet

- Dépôt de configuration de la plateforme d'hébergement de l'équipe Infra (pas d'application à compiler, pas de Node.js).
- Services Docker Compose : `proxy` (Nginx), `wiki` (Wiki.js), `grafana`, `db` (PostgreSQL), déployés dans `/opt/stack` sur `srv-01` et `srv-02`.
- Fichiers clés : `docker-compose.yml`, `nginx/conf.d/`, `scripts/deploy.sh`, `Makefile`, `docs/infra.md` (inventaire), `docs/adr/` (décisions).

## Commandes de vérification (à lancer avant de proposer un changement)

- `make lint` : `shellcheck` sur les scripts et `yamllint` sur le YAML
- `make check` : `docker compose config -q` et `nginx -t`
- Si une vérification échoue : corriger la cause, ou le signaler dans la PR. Ne jamais la désactiver ou la supprimer.

## Conventions

- GitHub Flow : une branche par issue, `<type>/<n° issue>-<description>` ; `main` est protégée, tout passe par une PR.
- Commits au format Conventional Commits : `type(scope): description` à l'impératif.
- Utiliser le modèle de PR et lier l'issue (`Closes #N`) ; signaler dans la PR que le changement a été produit avec une IA.
- Images Docker avec une version fixée (jamais `:latest`).
- Secrets uniquement dans `.env` (ignoré par Git), avec les clés documentées dans `.env.example`.

## Interdits

- Aucun secret (mot de passe, token, clé) dans le code, la documentation ou les messages de commit.
- Ne jamais pousser directement sur `main`, ni merger sa propre PR.
- Ne jamais déployer ni exécuter de commande sur `srv-01`, `srv-02`, `fw-01` ou `vpn-01` : proposer, l'humain exécute.
- Pas de connexion `root`, pas de `StrictHostKeyChecking=no`, pas de `curl … | bash`, pas de `chmod 777`.
- Ne jamais utiliser `docker compose down -v` (supprime les données).
- Ne pas publier de nouveau port sur l'hôte (bases de données notamment) ni ouvrir de règle pare-feu `any`.
- Si une information manque, poser la question au lieu de l'inventer.
