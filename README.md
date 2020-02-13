# Resources Module

This module creates commonly used cloud resources in a single resource group in a single region.

![Resources](./.docs/resources.png)

---

## Table of Contents
1. [Endpoints](##Endpoints)
2. [Certificate Manager](##Certificate-Manager)
3. [Key Protect](##Key-Protect)
4. [Cloud Object Storage](##Cloud-Object-Storage)
5. [Databases For PostgreSQL](##Databases-For-PostgreSQL)
6. [Activity Tracker](##Activity-Tracker)
7. [LogDNA](##LogDNA)
8. [Sysdig](##Sysdig)
9. [Module Variables](##module-variables)
9. [Outputs](##Outputs)
10. [As a Module in a Larger Architecture](##As-a-Module-in-a-Larger-Architecture)


---

## Endpoints

This module creates all resources with either `public` or `private` endpoints. These endpoints are used for all resource instances

---

## Certificate Manager

Creates a certificiate manager instance with HMAC parameters. 

IBM Cloud™ Certificate Manager helps you to obtain, store and manage SSL/TLS certificates that you use for IBM Cloud deployments, or other Cloud and on-prem deployments.<sup>[1](https://cloud.ibm.com/docs/certificate-manager?topic=certificate-manager-about-certificate-manager)</sup>

You can import SSL/TLS certificates that you obtain for your apps and services, store them securely, and get a central view of the certificates that you are using. Or, you can order public certificates through Certificate Manager from supported CAs.<sup>[2](https://cloud.ibm.com/docs/certificate-manager?topic=certificate-manager-about-certificate-manager)</sup>

### More Info

For more about certificate manager read the documentation [here](https://cloud.ibm.com/docs/certificate-manager?topic=certificate-manager-about-certificate-manager)

---

## Key Protect

Creates an instance of Ket Protect and a Key Protect Root Key to encrypt the [Cloud Object Storage](##Cloud-Object-Storage) and [Databases For PostgreSQL](##Databases-For-PostgreSQL) instances.

IBM® Key Protect for IBM Cloud™ helps you provision encrypted keys for apps across IBM Cloud services. As you manage the lifecycle of your keys, you can benefit from knowing that your keys are secured by FIPS 140-2 Level 3 certified cloud-based hardware security modules (HSMs) that protect against the theft of information.<sup>[3](https://cloud.ibm.com/docs/key-protect?topic=key-protect-about)</sup>

### More Info

For more about Key Protect read the documentation [here](https://cloud.ibm.com/docs/key-protect?topic=key-protect-about)

---
## Cloud Object Storage

Creates a Cloud Object Storange instance encrypted with the [Key Protect](##Key-Protect) root key. This also creates a service-to-service authorization policy with Key Protect to allow the COS instance to read from Key Protect for encryption.

### COS Bucket

Optionally wil create a Cloud Object Storage bucket.

### More Info

Read more about Cloud Object Storage [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started).

---
## Databases For PostgreSQL

Creates an instance of Databases for PostgreSQL encrypted with the [Key Protect](##Key-Protect) root key. This also creates a service-to-service authorization policy with Key Protect to allow the Postgres instance to read from Key Protect for encryption.

#### More Info

Read more about Databases for PostgreSQL [here](https://cloud.ibm.com/docs/services/databases-for-postgresql?topic=databases-for-postgresql-getting-started).

---
## Activity Tracker

Optionally provisions an instance of Activity Tracker. There can only be one instance of Activity Tracker per account per region. 

---
## LogDNA

Provisions an instance of IBM Log Analysis with LogDNA.

Use IBM® Log Analysis with LogDNA to add log management capabilities to your IBM Cloud architecture. IBM Log Analysis with LogDNA is operated by LogDNA in partnership with IBM.<sup>[4](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started)</sup>

### More Info

Read more about IBM Log Analysis with LogDNA [here](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started).

---

## Sysdig

Provisions an instance of IBM Cloud Monitoring with Sysdig.

IBM Cloud Monitoring with Sysdig is a third-party cloud-native, and container-intelligence management system that you can include as part of your IBM Cloud architecture. Use it to gain operational visibility into the performance and health of your applications, services, and platforms. It offers administrators, DevOps teams and developers full stack telemetry with advanced features to monitor and troubleshoot, define alerts, and design custom dashboards. IBM Cloud Monitoring with Sysdig is operated by Sysdig in partnership with IBM.<sup>[5](https://cloud.ibm.com/docs/services/Monitoring-with-Sysdig?topic=Sysdig-getting-started)</sup>
### More Info
Read more about IBM Cloud Monitoring with Sysdig [here](https://cloud.ibm.com/docs/services/Monitoring-with-Sysdig?topic=Sysdig-getting-started).

---

## Module Variables

Variable            | Type    | Description                                                                    | Default
--------------------|---------|--------------------------------------------------------------------------------|--------
`ibmcloud_apikey`          | String  | The IBM Cloud platform API key needed to deploy IAM enabled resources          |
`ibm_region`               | String  | IBM Cloud region where all resources will be deployed                          | `us-south`
`resource_group`           | String  | Name of resource group to provision resources                                  | `default`
`unique_id`                | String  |  Prefix for all resources created in the module. Must begin with a letter.     | `resources-module`
`tags`                     | List    | List of tags for resources                                                     | `["resources-module"]`
`end_points`               | String  | Sets the endpoints for the resources provisioned. Can be `public` or `private` | `public`
`cms_plan`                 | String | Service plan for Certificate Manager | `free`
`kms_plan`                 | String | Plan to use for provisioning Key Protect | `tiered-pricing`
`kms_root_key_name`        | String | Name for the root key to be created in the Key Protect instance | `root_key`
`cos_plan`                 | String | Plan for Cloud Object Storage | `standard`
`create_cos_bucket`        | String | Allows for optional creation of a COS bucket. Can be true or false | `true`
`cos_bucket_name`          | String | Bucket name for COS. Must be unique within account | `cloud-resources-demo-bucket`
`cos_bucket_storage_class` | String | COS bucket storage class. Accepted values: `standard`, `vault`, `cold`, `flex` | `standard`
`postgres_plan`            | String | Plan for PostgreSQL instance | `standard`
`activity_tracker`         | Boolean | Provision activity tracker, true or false. Accounts can only have one instance of Activity Tracker per region | `false`
`logging_plan`             | String | Service plan for LogDNA and Activity Tracker. | `7-day`
`monitor_plan`             | String | Service plan for Sysdig | `graduated-tier`

---

## Outputs

- `logdna_id`: GUID of LogDNA Instance
- `sysdig_id`: GUID of Sysdig Instance
- `cos_id`: GUID of COS Instance
- `psql_id`: GUID of PSQL Instance
- `kms_id`: GUID of KMS Instance
- `cms_id`: CRN of CMS instance

---

## As a Module in a Larger Architecture

Use the [`./module`](.module) folder to include this in a larger architecture

Declaring this Module:

### Using Default Variables

```
data ibm_resource_group resource_group {
  name = "<your resource group name>"
}

module resources {
    source             = "./<path to your code>"
    ibmcloud_apikey    = "<your ibm cloud api key>"
    ibm_region         = "<your value or reference>"
    resource_group_id  = "${data.ibm_resource_group.resource_group.id}"
    unique_id          = "<your value or reference>"
}
```

### Using Custom Variables

```
data ibm_resource_group resource_group {
  name = "<your resource group name>"
}

module resources {
    source                    = "./<path to your code>"
    ibmcloud_apikey           = "<your ibm cloud api key>"
    ibm_region                = "<your value or reference>"
    resource_group_id         = "${data.ibm_resource_group.resource_group.id}"
    unique_id                 = "<your value or reference>"          
    tags                      = "<your value or reference>"
    end_points                = "<your value or reference>"
    cms_plan                  = "<your value or reference>"
    kms_plan                  = "<your value or reference>"
    kms_root_key_name         = "<your value or reference>"
    cos_plan                  = "<your value or reference>"
    create_cos_bucket         = "<your value or reference>"
    cos_bucket_name           = "<your value or reference>"
    cos_bucket_storage_class  = "<your value or reference>"
    postgres_plan             = "<your value or reference>"
    activity_tracker          = "<your value or reference>"
    logging_plan              = "<your value or reference>"
    monitor_plan              = "<your value or reference>"
}

```