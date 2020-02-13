##############################################################################
# This file will create storage resource intances, 
# - creates a cloud object storage instance and a bucket,
##############################################################################


##############################################################################
# Create COS instance 
##############################################################################

resource ibm_resource_instance cos {
  name              = "${var.unique_id}-cos"
  service           = "cloud-object-storage"
  plan              = "${var.cos_plan}"
  location          = "global" 
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"

  parameters = {
    service-endpoints = "${var.end_points}"
    key_protect_key   = "${ibm_kp_key.root_key.crn}"
  }
  
  tags = "${var.tags}"

}

##############################################################################


##############################################################################
# Policy for KMS
##############################################################################

resource ibm_iam_authorization_policy cos_policy {
  source_service_name         = "cloud-object-storage"
  source_resource_instance_id = "${ibm_resource_instance.cos.id}"
  target_service_name         = "kms"
  target_resource_instance_id = "${ibm_resource_instance.kms.id}"
  roles                       = ["Reader"]
}

##############################################################################


##############################################################################
# Create COS Bucket (Optional)
##############################################################################

resource ibm_cos_bucket cos_bucket {
  count                 = "${var.create_cos_bucket ? 1 : 0}"
  bucket_name           = "${var.cos_bucket_name}"
  resource_instance_id  = "${ibm_resource_instance.cos.id}"
  region_location       = "${var.ibm_region}"
  storage_class         = "standard"

  depends_on = ["ibm_iam_authorization_policy.cos_policy"]
}

##############################################################################