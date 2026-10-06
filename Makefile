.PHONY: lint check deploy

lint:            ## Analyse statique des scripts et du YAML
	shellcheck scripts/*.sh
	yamllint docker-compose.yml .github/

check:           ## Valide la configuration compose et Nginx
	docker compose config -q
	docker run --rm -v $(PWD)/nginx/conf.d:/etc/nginx/conf.d:ro nginx:1.27-alpine nginx -t

deploy:          ## Déploie sur HOST (ex : make deploy HOST=srv-01)
	./scripts/deploy.sh $(HOST)
