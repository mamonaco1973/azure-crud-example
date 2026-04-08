#!/bin/bash
set -euo pipefail

./check_env.sh


# ── Phase 1: Functions + Cosmos DB ────────────────────────────────────────────

echo "NOTE: Deploying functions and Cosmos DB..."
cd 01-functions
terraform init -upgrade
terraform apply -auto-approve

FUNC_APP_NAME=$(terraform output -raw function_app_name)
API_BASE=$(terraform output -raw function_app_url)
cd ..

export API_BASE
echo "NOTE: Function app: ${FUNC_APP_NAME}"
echo "NOTE: API base:     ${API_BASE}"


# ── Phase 2: Web app ──────────────────────────────────────────────────────────

echo "NOTE: Building web app..."
envsubst < 02-webapp/index.html.tmpl > 02-webapp/index.html

cd 02-webapp
terraform init -upgrade
terraform apply -auto-approve

WEBSITE_URL=$(terraform output -raw website_url)
cd ..

echo ""
echo "NOTE: Deployment complete."
echo "NOTE: API:     ${API_BASE}"
echo "NOTE: Web app: ${WEBSITE_URL}index.html"
echo ""

./validate.sh
