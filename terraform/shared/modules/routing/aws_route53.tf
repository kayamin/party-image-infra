# 外部公開するalb用のホストゾーンを作成
resource "aws_route53_zone" "public" {
  name = var.domain_name
  comment = "${var.service_name} のインターネット経由通信の名前解決用ホストゾーン"

  lifecycle {
    prevent_destroy = false
  }

  tags = var.cost_allocation_tags
}

# ALB用のSSL証明書を作成
# 1. ドメインに対して証明書を準備
resource "aws_acm_certificate" "app" {
  domain_name = var.domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate" "wild" {
  domain_name = "*.${var.domain_name}"
  validation_method = "DNS"
}

# 2. そのドメインに紐a付ける route53 ホストゾーンに acm の証明書に対して，ドメインの所有者であることを証明するためのレコードを作成
# (CNAME レコード）
resource "aws_route53_record" "app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.public.id
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  ttl = 60
}

# 3. 証明書に対応するドメインを所有していることを確認
resource "aws_acm_certificate_validation" "app_cert" {
  certificate_arn = aws_acm_certificate.app.arn
  validation_record_fqdns = [for record in aws_route53_record.app_cert_validation : record.fqdn]
}

# ALB への Alias レコードを作成
resource "aws_route53_record" "alb_line" {
  name = "line.${aws_route53_zone.public.name}"
  zone_id = aws_route53_zone.public.zone_id
  type = "A"

  alias {
    name = aws_alb.public.dns_name
    zone_id = aws_alb.public.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_publish" {
  name = "publish.${aws_route53_zone.public.name}"
  zone_id = aws_route53_zone.public.zone_id
  type = "A"

  alias {
    name = aws_alb.publish.dns_name
    zone_id = aws_alb.publish.zone_id
    evaluate_target_health = true
  }
}