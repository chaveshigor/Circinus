# frozen_string_literal: true

module S3
  class ShowService < ApplicationService
    def initialize
      @bucket_name = ENV['S3_BUCKET_NAME'].freeze
    end

    def run(s3_key)
      @s3_key = s3_key
      show_url
    end

    private

    attr_reader :s3_key, :bucket_name

    def show_url
      signer = Aws::S3::Presigner.new
      url, = signer.presigned_request(:get_object, bucket: bucket_name, key: s3_key)
      url
    end
  end
end
