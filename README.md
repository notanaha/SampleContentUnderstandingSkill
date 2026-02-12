# AI Search Index with Content Understanding Skill

This repository contains REST API definitions to build an Azure AI Search Index using the Content Understanding Skill. The setup enables document chunking, image verbalization, and vector search capabilities.

## Overview

The REST files should be executed in order:

| File | Description |
|------|-------------|
| `01_ks1-themepark-guide-datasource.rest` | Creates a data source connecting to Azure Blob Storage |
| `02_ks1-themepark-guide-index.rest` | Defines the search index schema with vector search and semantic configuration |
| `03_ks1-themepark-guide-skillset.rest` | Configures the skillset with Content Understanding, embeddings, and image verbalization |
| `04_ks1-themepark-guide-indexer.rest` | Creates the indexer to process documents |
| `99_themepark-query.rest` | Sample query to test the index |

## Architecture

```
Azure Blob Storage → Content Understanding Skill → Chunking + Image Extraction
                                                        ↓
                                    Text Embedding (text-embedding-3-large)
                                                        ↓
                                    Image Verbalization (ChatCompletionSkill)
                                                        ↓
                                    Image Embedding (text-embedding-3-large)
                                                        ↓
                                            AI Search Index
```

## Prerequisites

- Azure AI Search service (2025-11-01-Preview API)
- Azure Blob Storage account with documents
- Azure OpenAI service with `text-embedding-3-large` deployment
- Azure AI Services (for Content Understanding)

## Variables to Configure

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

## Usage

1. Install the [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension for VS Code
2. Replace all `<<<variable>>>` placeholders with your actual values
3. Execute each `.rest` file in numerical order by clicking "Send Request"
4. After the indexer completes, use `99_themepark-query.rest` to test queries

## Features

- **Content Understanding Skill**: Extracts text sections and images from documents
- **Text Chunking**: 2000 characters with 200 character overlap
- **Image Verbalization**: Uses GPT model to generate text descriptions of images
- **Vector Search**: 3072-dimensional embeddings with HNSW algorithm and scalar quantization
- **Semantic Search**: BM25 similarity with semantic ranking

## API Version

All REST calls use Azure AI Search API version `2025-11-01-Preview`.

## License

MIT
