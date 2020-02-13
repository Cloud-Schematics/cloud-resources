##############################################################################
# Create Key Protect Instance
##############################################################################

resource ibm_resource_instance kms {
  name              = "${var.unique_id}-kms"
  service           = "kms"
  plan              = "${var.kms_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  
  parameters = {
    service-endpoints = "${var.end_points}"
  }

  tags = "${var.tags}"

}

##############################################################################


##############################################################################
# Key Protect Root Key
##############################################################################

resource ibm_kp_key root_key {
  key_protect_id  = "${ibm_resource_instance.kms.guid}"
  key_name        = "${var.kms_root_key_name}"
  standard_key    = false
}

##############################################################################