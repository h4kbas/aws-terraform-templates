provider "aws" {
  region = "us-west-2"
}


locals {
  s3_origin_id = "myS3Origin"
  src_dir = "~/Desktop/ordek.jpg"
}

resource "aws_s3_bucket" "soulmeet_files" {
  bucket = "soulmeet"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "index" {
  bucket        = aws_s3_bucket.soulmeet_files.id
  key           = "ordek.jpg"
  source        = "${local.src_dir}/ordek.jpg"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  enabled             = true
  is_ipv6_enabled     = true

  origin {
    domain_name = aws_s3_bucket.soulmeet_files.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}