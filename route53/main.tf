terraform {
  required_version = "~> 1.3.0"
  }

resource "aws_route53_zone" "hosted_zone" {
  name = var.domain
  comment = "CloudResume"

  tags = {
    Environment = "Prod"
  }
}

resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.host_name
  type    = "A"
  #ttl     = 300
  #records = [aws_eip.lb.public_ip]
  alias {
    name                   = var.cloudfront_dns
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  } 
}