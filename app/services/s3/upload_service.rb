# frozen_string_literal: true

class S3::UploadService < ApplicationService
  def initialize(file_path)
    @file_path = file_path
    @file_name = file_path.split('/').last
    @bucket_name = ENV['S3_BUCKET_NAME'].freeze
    @bucket_folder = ENV['S3_MAIN_FOLDER_NAME'].freeze
  end
  
  def run
    upload
  end

  private

  attr_reader :file_path, :file_name, :bucket_name, :bucket_folder

  def upload
    s3 = Aws::S3::Client.new
    s3_key = ''

    File.open(file_path, 'rb') do |file|
      extention = File.extname(file)
      extention = extention[1..extention.length-1]
      s3_key = "#{bucket_folder}/#{file_name}"
      s3.put_object({body: file, bucket: bucket_name, key: s3_key, content_type: "image/#{extention}"})
    end

    s3_key
  end
end
