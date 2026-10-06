# Inventaire

| Machine | Rôle | Réseau |
| --- | --- | --- |
| srv-01 | Hôte Docker (services web, reverse proxy Nginx) | 10.0.10.11 |
| srv-02 | Hôte Docker (supervision, bases de données) | 10.0.10.12 |
| fw-01 | Pare-feu périmétrique | 10.0.0.1 |
| vpn-01 | Serveur WireGuard (UDP 51820) pour les télétravailleurs | 10.0.0.20 |

- Les certificats TLS sont renouvelés à la main (Let's Encrypt, certbot) tous les 90 jours.
- Les services tournent dans `/opt/stack` sur chaque hôte, avec `docker compose`.
- Le déploiement se fait avec l'utilisateur `deploy` (clé SSH), jamais en root.
- Astreinte : canal `#infra-astreinte`.
