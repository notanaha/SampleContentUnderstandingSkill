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

REST files automatically load variables from the `.env` file using the `{{$dotenv VARIABLE_NAME}}` syntax (VS Code REST Client format).

**Setup Instructions:**

1. Copy `sample.env` to `.env`:
   ```bash
   cp sample.env .env
   ```

2. Edit `.env` and set the following values with your Azure resource details:

| Environment Variable | Description |
|----------|-------------|
| `AZURE_SEARCH_API_KEY` | Azure AI Search admin API key |
| `AZURE_SEARCH_ENDPOINT` | Azure AI Search endpoint (e.g., `https://mysearch.search.windows.net`) |
| `AZURE_OPENAI_ENDPOINT` | Azure OpenAI endpoint URL (can be a different Foundry account from AI Services) |
| `AZURE_OPENAI_API_KEY` | Azure OpenAI API key |
| `AI_SERVICES_URL` | Azure AI Services endpoint for Content Understanding (can be a different Foundry account from Azure OpenAI) |
| `AI_SERVICES_KEY` | Azure AI Services API key |
| `AZURE_BLOB_CONNECTION_STRING` | Azure Blob Storage connection string |
| `AZURE_BLOB_CONTAINER_NAME` | Blob container name containing the documents |

> **Note:** `AZURE_OPENAI_ENDPOINT` and `AI_SERVICES_URL` are kept separate intentionally.
> AI Services (Content Understanding) may have region availability restrictions, so you can deploy Azure OpenAI on a different Foundry account without being constrained by those limitations.

The REST files will automatically read these values from `.env` file without any hardcoding, so you won't need to modify variable values in the REST files themselves.

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
2. Create a `.env` file by copying `sample.env`:
   ```bash
   cp sample.env .env
   ```
3. Open `.env` and fill in your Azure resource endpoints and API keys
4. Open each `.rest` file (they will automatically use values from `.env`)
5. Execute each `.rest` file in numerical order by clicking "Send Request"
6. After the indexer completes, use `99_themepark-query.rest` to test queries

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
- **Japanese Analyzer**: `snippet` field uses `ja.microsoft` analyzer for Japanese-language tokenization
- **Vector Search**: 3072-dimensional embeddings with HNSW algorithm and scalar quantization
- **Semantic Search**: BM25 similarity with semantic ranking
- **Agentic Retrieval**: Knowledge base–driven retrieval with intelligent query planning
- **MCP Integration**: Model Context Protocol tool connecting Foundry Agent Service to Azure AI Search
- **Web Knowledge Source**: Augment index-based retrieval with live web search

## Prompt Tuning Notes

This solution includes prompt tuning at the following three points.

### 1. Image Verbalization Prompt (`03_ks1-themepark-guide-skillset.rest` L77)

The `systemMessage` in the `ChatCompletionSkill` is tuned to extract structured information from images.

### 2. Knowledge Base `retrieval_instructions` (`101_knowledge_base.ipynb` — Create Knowledge Base )

The `retrieval_instructions` on `kb2` guide the knowledge base on which knowledge source to select.

### 3. Agent `instructions` (`101_knowledge_base.ipynb` — Create Agent )

The `instructions` passed to the Foundry Agent describe how to use the knowledge base tool.

## Analyzer Configuration

The index definition (`02_ks1-themepark-guide-index.rest`) specifies `"analyzer": "ja.microsoft"` on the `snippet` field. This is the Microsoft Japanese language analyzer, which provides morphological analysis optimized for Japanese text. It correctly tokenizes Japanese sentences — which do not use spaces between words — enabling accurate full-text search.

If the target documents are in a different language, change the analyzer to the appropriate one (e.g., `en.microsoft` for English). See [Language analyzers in Azure AI Search](https://learn.microsoft.com/azure/search/index-add-language-analyzers) for the full list of supported analyzers.

## API Version

All REST calls use Azure AI Search API version `2025-11-01-Preview`.

## License

MIT
