# Video Script — Serverless CRUD API on Azure with Functions and Cosmos DB

---

## Introduction

[ Screen recording of the Notes Demo web app — creating, editing, and deleting notes in the browser ]

"Do you need a working serverless CRUD API on Azure?

[ Architecture diagram — walk through it left to right: browser, storage account, Function App, Cosmos DB ]

"In this project we build a fully serverless notes API using Azure Functions, Cosmos DB, and storage account — all provisioned with Terraform and deployed with a single script."

[ index.html in the browser — note list on the left, editor on the right ]

"The frontend is a static web app hosted on storage account. It talks to a Python Function App that handles all four operations — Create, Read, Update, and Delete — backed by Cosmos DB."

[ Terminal running apply.sh — Terraform output flying by, ending with the website URL ]

"Follow along and in minutes you'll have a working CRUD API running in Azure."

---

## Architecture

[ Full diagram ]

"Let's walk through the architecture before we build."

[ Highlight browser and storage account ]

"The user opens a static web page — just an HTML page served directly from an Azure storage account."

[ Highlight Function App ]

"The frontend talks to an Azure Function App over HTTP. One Python file handles all the routes — POST to create, GET to list, GET by ID, PUT to update, DELETE to remove."

[ Highlight Cosmos DB ]

"The backend stores data in Cosmos DB. Each note is a JSON document. The Function App connects using the Cosmos DB endpoint."

---

## Build the Code

[ Terminal — running ./apply.sh ]

"The whole deployment is one script — apply.sh. Three phases."

[ Terminal — Phase 1: Terraform apply ]

"Phase one: Terraform provisions the Function App and Cosmos DB — storage account for the code, the database, the app itself, all wired together."

[ Terminal — Phase 2: zip deploy ]

"Phase two: the Python code gets zipped and pushed to Azure with --build-remote. Dependencies install in the cloud — no local Python needed."

[ Terminal — Phase 3: webapp Terraform ]

"Phase three: envsubst injects the Function App URL into the HTML template. Terraform drops the file into storage account and the site is live."

[ Terminal — deployment complete, URLs printed ]

"API URL. Website URL. Done."

---

## Build Results

[ Azure Portal — Resource Groups ]

"Two resource groups are created — one for the Function App and Cosmos DB, and one for the web frontend."

[ Azure Portal — Function App ]

"First — the Function App. This is the entire compute layer for the project."

[ Show Routes ]

"These are the routes — create, list, get, update, and delete."

[ Azure Portal — Cosmos DB container ]

"Next — Cosmos DB. This is the storage layer for the API."

[ Azure Portal — Storage Account, $web container ]

"Finally, a storage account hosts the static web application."

[ Browser — Notes Demo loads ]

"Open the URL to launch the test application."

---

## Demo

[ Browser — Notes Demo, open DevTools → Network tab ]

"Open the web app — and the browser debugger so we can watch the API calls."

[ Refresh page — network calls visible ]

"When the app loads, it calls the list endpoint. No notes yet."

[ Clicking New — modal opens, typing a title, clicking Create ]

"Now let’s create a new note by selecting New."

[ Show API working ]

"A POST to the API is made which returns an ID."

[ Clicking the note in the list ]

"The new note is also selected and the API loads the content."

[ Editing and clicking Save ]

"Now let’s update the note and select Save."

[ Show network tab ]

"A PUT call is made — and the updated data is stored in Cosmos DB."

[ Clicking Delete ]

"Now let’s delete the note by selecting Delete.

[ Show network ]

"A DELETE call is made — and the note is removed."

[ Browser — empty list ]

"In this demo, we’ve now exercised every API endpoint."

---
