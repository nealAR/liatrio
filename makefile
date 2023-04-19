infra:
	cd terraform && terraform init && terraform apply -var project_id='$(project_id)' -var region=us-east1 -var zone=us-east1-b
	
app:
	gcloud auth login
	gcloud config set project $(project_id)
	gcloud auth configure-docker us-east1-docker.pkg.dev -q
	docker build -t us-east1-docker.pkg.dev/$(project_id)/node-repo/liatrio-takehome --build-arg ENVIRONMENT=$(environment) .
	docker push us-east1-docker.pkg.dev/$(project_id)/node-repo/liatrio-takehome
	gcloud container clusters get-credentials liatrio-test-cluster --zone=us-east1-b
	sed -i "" 's/ENVIRONMENT/$(environment)/g' src/manifest/deployment.yaml
	kubectl apply -f src/manifest/*.yaml
	sed -i "" 's/$(environment)/ENVIRONMENT/g' src/manifest/deployment.yaml
destroy:
	cd terraform && terraform init && terraform destroy