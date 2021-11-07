resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "apps.cloudskills.link"
  type    = "A"
  alias {
    name = module.alb.this_lb_dns_name
    zone_id = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }
}