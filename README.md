# AI Search Index with Content Understanding Skill

This repository contains REST API definitions to build an Azure AI Search Index using the Content Understanding Skill, along with a Jupyter notebook for building an agentic retrieval pipeline with Knowledge Bases.

## Overview

### Part 1: Index Creation (REST Files)

The REST files should be executed in order to create and populate the search index:

| File | Description |
|------|-------------|
| `01_ks1-themepark-guide-datasource.rest` | Creates a data source connecting to Azure Blob Storage |
| `02_ks1-themepark-guide-index.rest` | Defines the search index schema with vector search and semantic configuration |
| `03_ks1-themepark-guide-skillset.rest` | Configures the skillset with Content Understanding, embeddings, and image verbalization |
| `04_ks1-themepark-guide-indexer.rest` | Creates the indexer to process documents |
| `99_themepark-query.rest` | Sample query to test the index |

### Part 2: Agentic Retrieval with Knowledge Bases (Notebook)

| File | Description |
|------|-------------|
| `101_knowledge_base.ipynb` | End-to-end agentic retrieval pipeline using Azure AI Search Knowledge Bases and Foundry Agent Service |

The notebook walks through:

1. Loading environment variables and setting up connections
2. Creating knowledge sources (search index + web)
3. Creating knowledge bases with extractive or answer-synthesis output modes
4. Testing knowledge base retrieval directly
5. Creating a Foundry Agent Service agent with an MCP tool connected to the knowledge base
6. Starting a chat with the agent
7. (Optional) Adding a remote SharePoint knowledge source
8. Cleanup of all created resources

## Prerequisites

### For REST Files (Part 1)

- Azure AI Search service (2025-11-01-Preview API)
- Azure Blob Storage account with documents
- Azure OpenAI service with `text-embedding-3-large` deployment
- Azure AI Services (for Content Understanding)

### For Notebook (Part 2)

- Azure AI Search service in a [region that supports agentic retrieval](https://learn.microsoft.com/azure/search/search-region-support)
- A [Microsoft Foundry project](https://learn.microsoft.com/azure/ai-foundry/how-to/create-projects) and resource
- A [supported LLM](https://learn.microsoft.com/azure/search/search-agentic-retrieval-how-to-create#supported-models) deployed to your project (e.g., `gpt-5-mini`)
- Azure OpenAI service with a text embedding model (e.g., `text-embedding-3-large`)
- Python 3.13+ with packages listed in `requirements.txt`
- A `.env` file based on `sample.env` with your Azure endpoints and keys

## Variables to Configure

### REST Files

Replace the following variables (marked as `<<<variable>>>`) in the REST files:

| Variable | Description | Used In |
|----------|-------------|---------|
| `<<<search instance>>>` | Azure AI Search instance name (e.g., `mysearch`) | All files |
| `<<<search-api-key>>>` | Azure AI Search admin API key | All files |
| `<<<data source name>>>` | Name for the data source | 01, 04 |
| `<<<connection string>>>` | Azure Blob Storage connection string | 01 |
| `<<<index name>>>` | Name for the search index | 02, 04, 99 |
| `<<<skillset name>>>` | Name for the skillset | 03, 04 |
| `<<<indexer name>>>` | Name for the indexer | 04 |
| `<<<foundry name>>>` | Azure OpenAI resource name | 02, 03 |
| `<<<api-key>>>` | Azure OpenAI API key | 02, 03 |
| `<<<deployment name>>>` | Azure OpenAI chat model deployment name | 03 |
| `<<<foundry name for CU>>>` | Azure AI Services resource name for Content Understanding | 03 |

### Notebook

Copy `sample.env` to `.env` and set the following variables:

| Variable | Description |
|----------|-------------|
| `PROJECT_ENDPOINT` | Microsoft Foundry project endpoint |
| `PROJECT_RESOURCE_ID` | Full Azure resource ID of the Foundry project |
| `AZURE_OPENAI_ENDPOINT` | Azure OpenAI service endpoint |
| `AZURE_OPENAI_GPT_DEPLOYMENT` | GPT model deployment name (default: `gpt-5-mini`) |
| `AZURE_SEARCH_ENDPOINT` | Azure AI Search endpoint |
| `AZURE_SEARCH_INDEX` | Name of the search index to use |
| `AZURE_SEARCH_API_KEY` | Azure AI Search API key (optional if using managed identity) |

## Usage

### REST Files

1. Install the [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension for VS Code
2. Replace all `<<<variable>>>` placeholders with your actual values
3. Execute each `.rest` file in numerical order by clicking "Send Request"
4. After the indexer completes, use `99_themepark-query.rest` to test queries

### Notebook

1. Create a Python virtual environment and install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Copy `sample.env` to `.env` and fill in your Azure resource details
3. Open `101_knowledge_base.ipynb` in VS Code and run cells sequentially
4. The notebook creates knowledge sources, knowledge bases, and a Foundry agent that uses an MCP tool for agentic retrieval

## Features

- **Content Understanding Skill**: Extracts text sections and images from documents
- **Text Chunking**: 2000 characters with 200 character overlap
- **Image Verbalization**: Uses GPT model to generate text descriptions of images
- **Vector Search**: 3072-dimensional embeddings with HNSW algorithm and scalar quantization
- **Semantic Search**: BM25 similarity with semantic ranking
- **Agentic Retrieval**: Knowledge base–driven retrieval with intelligent query planning
- **MCP Integration**: Model Context Protocol tool connecting Foundry Agent Service to Azure AI Search
- **Web Knowledge Source**: Augment index-based retrieval with live web search

## API Version

All REST calls use Azure AI Search API version `2025-11-01-Preview`.

## License

MIT
