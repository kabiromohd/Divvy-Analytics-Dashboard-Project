# Divvy-Analytics-Dashboard-Project
Data Engineering Zoomcamp Capstone Project

## Purpose of project

The project is to build an end-to-end Batch Data Engineering pipeline for an Analytics Dashboard project. 

The goal of this project is to build an end-to-end data data pipeline.

## Problem statement

- Develop a dashboard with atleast two tiles
- Select a dataset of interest
- Create a pipeline for processing this dataset and putting it to a datalake
- Create a pipeline for moving the data from the lake to a data warehouse
- Transform the data in the data warehouse: prepare it for the dashboard
- Building a dashboard to visualize the data

## The data
The data is provided by Divvy Bikeshare and contains information about bike rides in Washington DC. Downloadable files are available on the following [data link](https://divvy-tripdata.s3.amazonaws.com/index.html) The data used for the project is from 2023 to date.

## Technologies used

- Docker:- Containerization of applications 
- Google Cloud Storage GCS - Data Lake for storage
- Google Cloud BigQuery - Data warehouse for analytical purposes
- Kestra - Data and workflow orchestration
- dbt- For analytics engineering via data transformation
- Google Looker studio - Data Visualization


## Steps to reproduce project:

Important: This project is intended to be easily reproducible. This section will give a thorough breakdown of how to reproduce this project

## 1) Pre-requisites
- Install Docker
  
## 2) Google Cloud Platform (GCP)
- Setup up GCP free account if you don't have an account. It expires after 90 days.
- Create a new project and take note of the project ID.
- Set up service account. Select Bigquery Admin, Compute Admin and storage Admin Roles for this project.
- Once account is created, create and download the key file. This will be used to authenticate google services. This will be needed for Kestra, dbt setup.

## 3) Setup Kestra
- Setup working Environment either a VM on GCP or on your local machine cloud. Open your terminal, clone the project repo and then launch Kestra UI
  
```
  git clone https://github.com/kabiromohd/Divvy-Analytics-Dashboard-Project.git

  cd Divvy-Analytics-Dashboard-Project/Orchestration-kestra/

  docker-compose up

```

- Run the below command to load the already prepared project YAML flows into the Kestra application.

```
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/04_gcp_kv.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/05_gcp_setup.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/09_gcp_capstone1
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/09_gcp_scheduled_capstone1

```

- Open the Kestra UI on https://localhost:8080
  
Run the following inside of Kestra UI

- Inserting the GCP Service Account credentials in 04_gcp_kv.yaml flow.

- Execute: 04_gcp_kv.yaml and 05_gcp_setup.yaml flows to setup your GCS - Datalake and BigQuery - Data Warehouse
  
- Execute: 09_gcp_capstone1, if you desire to ingest monthly data from the API into GCS (datalake) BigQuery (data warehouse) one by one.
  
- 09_gcp_scheduled_capstone1 to ingest data from the API into GCS (datalake) BigQuery (data warehouse) via a backfill. Note that a trigger has been setup in this flow to ingest data as new data becomes available on the API

## Display of Kestra UI (http://localhost:8080)

![Kestra UI](https://github.com/user-attachments/assets/7765f52f-1925-408c-8c92-c28add6ee7e3)

## Display of GCS-BigQuery

![BigQuery](https://github.com/user-attachments/assets/aa9a7b78-0874-4082-83e0-128f82432788)

## 3) Setup dbt for Analytics Engineering 

