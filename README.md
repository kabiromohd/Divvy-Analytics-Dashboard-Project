# Divvy-Analytics-Dashboard-Project
Data Engineering Zoomcamp Capstone Project

## Purpose of project

The project is to build an end-to-end Batch Data Engineering Analytics Dashboard project. 

The goal of this project is to build an end-to-end data pipeline.

## Problem statement

- Develop a dashboard with two tiles by:
- Selecting a dataset of interest (see Datasets)
- Creating a pipeline for processing this dataset and putting it to a datalake
- Creating a pipeline for moving the data from the lake to a data warehouse
- Transforming the data in the data warehouse: prepare it for the dashboard
- Building a dashboard to visualize the data

## The data
The data is provided by Divvy Bikeshare and contains information about bike rides in Washington DC. Downloadable files are available on the following [link](https://divvy-tripdata.s3.amazonaws.com/index.html) The data used for the project is from 2023 to date.

Dataset columns from source:

- ride_id - Unique key for each ride
- rideable_type - Bike type used
- started_at – Includes start date and time
- ended_at – Includes end date and time
- start_station_name – Includes starting station name
- start_station_id - Unique id of start station
- end_station_name – Includes ending station name
- end_station_id - Unique id of ending station
- start_lat - Start Latitude of bike trip
- start_lng - Start Longitude of bike trip
- end_lat - Latitude the bike trips end
- end_lng - Longitude the bike trips end
- member_casual- Indicates whether user was a "registered" member (Annual Member, 30-Day Member or Day Key Member) or a "casual" rider (Single Trip, 24-Hour Pass, 3-Day Pass or 5-Day Pass)

## Technologies used

- Docker:- Containerization of applications -- build, share, run, and verify applications anywhere — without tedious environment configuration or management.
- Google Cloud Storage GCS - Data Lake for storage
- Google Cloud BigQuery - Data warehouse for analytical purposes
- Kestra - Data and workflow orchestration
- dbt- For analytics engineering via data transformation
- Google Looker studio - Data Visualization


## Steps to reproduce project:

Important: This project is intended to be easily reproducible. This section will give a thorough breakdown of how to reproduce this project

## 1) Pre-requisites
- Install terraform
- Install Docker
  
## 2) Google Cloud Platform (GCP)
- Setup up GCP free account if you don't have an account. It expires after 90 days.
- Create a new project and take note of the project ID.
- Set up service account. Select Bigquery Admin, Compute Admin and storage Admin Roles for this project.
- Once account is created, create and download the key file. This will be used to authenticate google services. This will be needed for Kestra, dbt.

## 3) Setup Kestra
- Setup working Environment either a VM on GCP or on your local machine cloud. Open your terminal, clone the project repo and then launch Kestra UI
  
```
  git clone https://github.com/kabiromohd/Divvy-Analytics-Dashboard-Project.git

  cd Divvy-Analytics-Dashboard-Project/Orchestration-kestra/

  docker-compose up

```

- Run the below codes to load the already prepared project YAML flows into the Kestra application.

```
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/04_gcp_kv.yaml
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/05_gcp_setup.yaml
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/09_gcp_capstone1
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/09_gcp_scheduled_capstone1

```
- Open the Kestra UI on https://localhost:8080
  
Run the following inside of Kestra UI
- Execute: 04_gcp_kv.yaml and 05_gcp_setup.yaml flows to setup your GCS and BigQuery services, after inserting the service account token in the 04_gcp_kv.yaml flow.
  
- Execute: 09_gcp_capstone1 or 09_gcp_scheduled_capstone1 to ingest data from the API into GCS (datalake) BigQuery (data warehouse)

## Display of Kestra UI (http://localhost:8080)

![Kestra UI](https://github.com/user-attachments/assets/7765f52f-1925-408c-8c92-c28add6ee7e3)

## Display of GCS-BigQuery

![BigQuery](https://github.com/user-attachments/assets/aa9a7b78-0874-4082-83e0-128f82432788)

## 3) Setup dbt for Analytics Engineering 

