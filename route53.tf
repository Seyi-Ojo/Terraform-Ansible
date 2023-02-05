resource "aws_route53_zone" "hmw-r53" {
  name = var.domain_name
}

resource "aws_route53_zone" "sub-domain-name" {
  name = "terraform-test.seyi-altschool.com"

  tags = {
    Environment = "sub-domain-name"
  }
}

resource "aws_route53_record" "hmw-alb-A" {
  zone_id = aws_route53_zone.hmw-r53.zone_id
  name    = "terraform-test.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.hmw-alb.dns_name
    zone_id                = aws_lb.hmw-alb.zone_id
    evaluate_target_health = true
  }
}