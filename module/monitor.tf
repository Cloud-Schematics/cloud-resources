##############################################################################
# Create monitoring with sysdig instance
##############################################################################

resource ibm_resource_instance sysdig {
  name              = "${var.unique_id}-sysdig"
  location          = "${var.ibm_region}"
  service           = "sysdig-monitor"
  plan              = "${var.monitor_plan}"
  resource_group_id = "${var.resource_group_id}"

  parameters = {
    service-endpoints = "${var.end_points}"
  }

  tags = "${var.tags}"

}

##############################################################################