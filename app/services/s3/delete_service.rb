# frozen_string_literal: true

class S3::DeleteService < ApplicationService
  def initialize(s3_key)
    @s3_key = s3_key
    @bucket_name = ENV['S3_BUCKET_NAME'].freeze
  end
  
  def run
    delete
  end

  private

  attr_reader :s3_key, :bucket_name

  def delete
    s3 = Aws::S3::Client.new
    s3.delete_object(bucket: bucket_name, key: s3_key)
  end
end
