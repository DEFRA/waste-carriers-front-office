# frozen_string_literal: true

require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  govpay_mocks_bucket = {
    name: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", "eu-west-1"),
    credentials: {
      access_key_id: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_ACCESS_KEY_ID", "dummy"),
      secret_access_key: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_SECRET_ACCESS_KEY", "dummy")
    },
    encrypt_with_kms: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_ENCRYPT_WITH_KMS", nil)
  }

  c.buckets = [govpay_mocks_bucket]
end
