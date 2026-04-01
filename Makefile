.PHONY: help elevate-permissions create-multipass stop-multipass destroy-multipass setup-ansible remove-ansible galaxy-install inject-hosts provision up

help: ## Show help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

elevate-permissions: ## Elevate permission for script files
	@echo "Preparing scripts in ./scripts/..."
# Ensure Windows line endings are removed
	@find ./scripts -name "*.sh" -exec perl -pi -e 's/\r$$//' {} + || true
	@chmod -R 755 ./scripts/

create-multipass: elevate-permissions ## Launch Multipass VMs for the swarm
	@echo "Running the VM creation script..."
	./scripts/multipass/create-multipass.sh

stop-multipass: elevate-permissions ## Stop all swarm VMs
	@echo "Running the VM stopping script..."
	./scripts/multipass/stop-multipass.sh

destroy-multipass: elevate-permissions ## Danger: Nuke all swarm VM instances
	@echo "WARNING: Destroying all swarm instances..."
	@echo -n "Are you sure? [y/N]: " && read ans && ([ $${ans:-N} = y ] || [ $${ans:-N} = Y ])
	@echo "Confirmed. Running the VM destruction script..."
	./scripts/multipass/destroy-multipass.sh

setup-ansible: elevate-permissions ## Install Ansible using brew and uv
	@echo "Running the Ansible installation script..."
	@./scripts/ansible/install-ansible.sh

remove-ansible: elevate-permissions ## Completely remove Ansible from the system
	@echo "Running the Ansible uninstallation script..."
	@./scripts/ansible/uninstall-ansible.sh

galaxy-install: ## Install Ansible Galaxy roles and collections
	ansible-galaxy role install -r ansible/requirements.yml
	ansible-galaxy collection install -r ansible/requirements.yml

inject-hosts: elevate-permissions ## Update Ansible inventory with current VM IPs
	./scripts/inject-dynamic-hosts.sh

provision: ## Run the swarm provisioning playbook
	ansible-playbook -i ansible/hosts.ini ansible/configure-swarm.yml

up: create-multipass inject-hosts galaxy-install provision ## Full pipeline: create VMs → configure inventory → provision swarm
