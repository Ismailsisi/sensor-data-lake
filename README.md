# Sensor Data Lake

Week 1 AWS data engineering practical project.

## Purpose

This repository contains AWS CLI scripts and configuration files used to provision an Amazon S3 data lake for industrial sensor data.

## Repository Structure

* scripts/ — AWS CLI provisioning scripts
* config/ — S3 lifecycle and related configuration
* sample-data/ — small example sensor datasets

## Provisioning

Git and AWS CLI version 2 are prerequisites.

The default AWS CLI profile is `training`.

The provisioning script is run with:

```bash
./scripts/create_s3_data_lake.sh
```

## Lifecycle

Objects under the `raw/` prefix transition to Standard-IA after 30 days and Glacier Flexible Retrieval after 180 days.

The training expiration is approximately seven years.

## Security

AWS credentials and private SSH keys must never be committed to this repository.

S3 Block Public Access is enabled.

