# multipass-swarm-mode

A full-stack application running on a local **Docker Swarm** cluster of **Multipass VMs**. The application itself is intentionally minimal — the focus is on the infrastructure: how a swarm is formed, how images are distributed, how traffic is routed, and how services discover each other at runtime.

---

## Architecture

Three Multipass VMs form the cluster: **1 manager** and **2 workers**. All nodes are provisioned by a single Ansible playbook, then the stack is deployed via `docker stack deploy`.



Swarm schedules replicas across nodes according to placement constraints — Traefik and PostgreSQL are pinned to the manager; frontend and backend replicas are spread freely across all nodes.

Traefik serves as the reverse proxy and load balancer, routing incoming requests to the appropriate service based on hostname. It also handles TLS termination using a self-signed certificate.

## Getting Started

### Prerequisites

- macOS with [Multipass](https://multipass.run/) installed
- `ansible`, `ansible-galaxy`
- SSH key at `~/.ssh/id_ed25519`

### Setup

```bash
git clone https://github.com/fn-jakubkarp/multipass-swarm-mode
cd multipass-swarm-mode
cp .env.example .env   # fill in credentials

make up                # VMs → inventory → Ansible → stack deploy
```

Access the app at `https://app.swarm.localhost`.

> The certificate in `./certs/` is self-signed — trust it in your browser or system keychain to avoid warnings.

### Teardown

```bash
make destroy
```

---

## Project Structure

```
multipass-swarm-mode/
├── .github/workflows/
│   └── publish-docker.yml      # Build & push images to GHCR
├── ansible/
│   ├── configure-swarm.yml     # Provisioning: Docker, Swarm init, stack deploy
│   ├── requirements.yml
│   └── hosts.ini               # Generated dynamically — do not edit
├── app/
│   ├── backend/                # FastAPI — Dockerfile (UV + Python)
│   └── frontend/               # React — Dockerfile (Bun + nginx)
├── db/
│   └── init.sql                # PostgreSQL schema
├── scripts/
│   ├── config.sh               # Node names and VM specs
│   ├── inject-dynamic-hosts.sh # Generates Ansible inventory from Multipass IPs
│   └── multipass/              # VM lifecycle scripts
├── cloud-init.yml              # VM bootstrap config
├── docker-stack.yml            # Docker Swarm stack definition
└── Makefile
```
