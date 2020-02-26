##############################################################################
# Create Activity Tracker with LogDNA instance
##############################################################################

resource ibm_resource_instance iks_on_vpc_activity_tracker {

  count             = "${var.activity_tracker ? 1 : 0}"

  name              = "${var.unique_id}-activity-tracker"
  service           = "logdnaat"
  plan              = "${var.logging_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"

  parameters = {
    service-endpoints = "${var.end_points}"
  }

  tags = "${var.tags}"

}
##############################################################################


##############################################################################
# create LogDNA instance
##############################################################################

resource ibm_resource_instance logdna {

  name              = "${var.unique_id}-logdna"
  service           = "logdna"
  plan              = "${var.logging_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"

  parameters = {
    service-endpoints = "${var.end_points}"
  }

  tags = "${var.tags}"
  
}

##############################################################################