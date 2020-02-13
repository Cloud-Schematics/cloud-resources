##############################################################################
# This file creates the PostgresSQL Database, creates a user with Postgres
# rbac, assign IAM policies
##############################################################################

##############################################################################
# Create Postgresql database
##############################################################################

resource "ibm_resource_instance" "postgresql" {
  name              = "${var.unique_id}-postgres"
  service           = "databases-for-postgresql"
  plan              = "${var.postgres_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"

  parameters = {
    service-endpoints = "${var.end_points}"
    key_protect_key   = "${ibm_kp_key.root_key.crn}"
  }

  //User can increase timeouts
  timeouts {
    create = "45m"
    update = "15m"
    delete = "15m"
  }

  tags = "${var.tags}"

}

##############################################################################


##############################################################################
# Policy for KMS
##############################################################################

resource ibm_iam_authorization_policy psql_policy {
  source_service_name         = "databases-for-postgresql"
  source_resource_instance_id = "${ibm_resource_instance.postgresql.id}"
  target_service_name         = "kms"
  target_resource_instance_id = "${ibm_resource_instance.kms.id}"
  roles                       = ["Reader"]
}

##############################################################################