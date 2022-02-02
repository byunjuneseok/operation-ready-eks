resource "aws_acm_certificate" "cluster_domain" {
  domain_name = var.cluster_domain_name
  subject_alternative_names = ["*.${var.cluster_domain_name}"]
  validation_method = "DNS"

  tags = local.common_tags
}

resource "aws_route53_record" "eks_domain_cert_validation_dns" {
  for_each = {
    for option in aws_acm_certificate.cluster_domain.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.cluster_domain.zone_id
}

resource "aws_acm_certificate_validation" "eks_domain_cert_validation" {
  certificate_arn         = aws_acm_certificate.cluster_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.eks_domain_cert_validation_dns : record.fqdn]
}

resource "aws_route53_record" "base" {
  zone_id = data.aws_route53_zone.cluster_domain.id
  name    = var.cluster_domain_name
  type    = "A"

  alias {
    name                   = local.lb_hostname
    zone_id                = data.aws_lb.ingress_nginx.zone_id
    evaluate_target_health = true
  }
}
