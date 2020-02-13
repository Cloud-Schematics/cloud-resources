##############################################################################
# This file creates the IBM Certificate manager resource instance
##############################################################################


##############################################################################
# Create certificate manager 
##############################################################################

resource ibm_resource_instance cms {
  
  name              = "${var.unique_id}-cms"
  service           = "cloudcerts"
  plan              = "${var.cms_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${var.resource_group_id}"

  parameters = {
    "HMAC"            = true
    service-endpoints = "${var.end_points}"
  }

  tags = "${var.tags}"

}

##############################################################################