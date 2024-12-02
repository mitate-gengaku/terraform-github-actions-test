data "aws_route53_zone" "name" {
  name = var.route53_domain_name
}

resource "aws_route53_record" "shomotsu_development_record" {
  zone_id = data.aws_route53_zone.name.zone_id
  name    = var.domain_name
  type    = "A"

  allow_overwrite = true

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}