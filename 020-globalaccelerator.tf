resource "aws_globalaccelerator_accelerator" "anycast-accelerator" {
  name = "anycast-accelerator"
  ip_address_type = "IPV4"
  enabled = true
}

resource "aws_globalaccelerator_listener" "anycast-listener-80" {
  accelerator_arn = aws_globalaccelerator_accelerator.anycast-accelerator.id
  client_affinity = "NONE"
  protocol = "TCP"

  port_range {
    from_port = 80
    to_port = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-80-east" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-80.id
  endpoint_group_region  = "us-east-1"
  health_check_port = 80
  health_check_protocol  = "HTTP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.us_east-1.PublicIPS
 content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-80-west" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-80.id
  endpoint_group_region  = "us-west-2"
  health_check_port = 80
  health_check_protocol  = "HTTP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.us_west-2.PublicIPS
  content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-80-eu-central" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-80.id
  endpoint_group_region  = "eu-central-1"
  health_check_port = 80
  health_check_protocol  = "HTTP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.eu-central-1.PublicIPS
  content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-80-ap-southeast-1" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-80.id
  endpoint_group_region  = "ap-southeast-1"
  health_check_port = 80
  health_check_protocol  = "HTTP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.ap-southeast-1.PublicIPS
  content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_listener" "anycast-listener-53" {
  accelerator_arn = aws_globalaccelerator_accelerator.anycast-accelerator.id
  client_affinity = "NONE"
  protocol = "UDP"

  port_range {
    from_port = 53
    to_port = 53
  }
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-53-east" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-53.id
  endpoint_group_region  = "us-east-1"
  health_check_port = 53
  health_check_protocol  = "TCP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.us_east-1.PublicIPS
 content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-53-west" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-53.id
  endpoint_group_region  = "us-west-2"
  health_check_port = 53
  health_check_protocol  = "TCP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.us_west-2.PublicIPS
  content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-53-eu-central" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-53.id
  endpoint_group_region  = "eu-central-1"
  health_check_port = 53
  health_check_protocol  = "TCP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.eu-central-1.PublicIPS
  content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group-53-ap-southeast-1" {
  listener_arn = aws_globalaccelerator_listener.anycast-listener-53.id
  endpoint_group_region  = "ap-southeast-1"
  health_check_port = 53
  health_check_protocol  = "TCP"
  health_check_path     = "/"
  dynamic "endpoint_configuration" {
  for_each = module.ap-southeast-1.PublicIPS
  content {
    endpoint_id = endpoint_configuration.value
    weight = 100
  }
}
}


output "GlobalAccelerator" {
  value = ["${aws_globalaccelerator_accelerator.anycast-accelerator.*.ip_sets}"]
}
