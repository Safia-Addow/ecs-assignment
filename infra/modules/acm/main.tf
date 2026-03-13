data "aws_route53_zone" "zone" {

  name = var.domain_name

}

resource "aws_acm_certificate" "cert" {

  domain_name = "${var.subdomain}.${var.domain_name}"

  validation_method = "DNS"

}
