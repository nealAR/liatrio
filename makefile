infra:
	cd terraform && terraform init && terraform apply -var project_id='$(project_id)' -var region=$(region) -var zone=$(zone)
	
app:
	gcloud auth login
	gcloud config set project $(project_id)
	gcloud auth configure-docker us-central1-docker.pkg.dev -q
	docker build -t $(region)-docker.pkg.dev/$(project_id)/node-repo/liatrio-takehome --build-arg ENVIRONMENT=makefile-deployment .
	docker push $(region)-docker.pkg.dev/$(project_id)/node-repo/liatrio-takehome
	gcloud container clusters get-credentials $(cluster-name) --zone=$(zone)
	sed -i "" 's/ENVIRONMENT/$(environment)/g' src/manifest/deployment.yaml
	kubectl apply -f src/manifest/*.yaml

destroy:
	cd terraform && terraform init && terraform destroy