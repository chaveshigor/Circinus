# frozen_string_literal: true

class S3::ShowService < ApplicationService
  def initialize(s3_key)
    @s3_key = s3_key
    @bucket_name = ENV['S3_BUCKET_NAME'].freeze
  end
  
  def run
    show_url
  end

  private

  attr_reader :s3_key, :bucket_name

  def show_url
    signer = Aws::S3::Presigner.new
    url, header = signer.presigned_request(:get_object, bucket: bucket_name, key: s3_key)
    url
  end
end
