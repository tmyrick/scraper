module AmazonAPI

  include HTTParty

  require 'time'
  require 'uri'
  require 'openssl'
  require 'base64'

  ACCESS_KEY_ID = Rails.application.secrets.aws_access_key_id
  SECRET_KEY = Rails.application.secrets.aws_secret_access_key
  ASSOCIATE_TAG = Rails.application.secrets.aws_associates_tag

  ENDPOINT = "webservices.amazon.com"
  REQUEST_URI = "/onca/xml"

  def self.generate_request_url(params)
    regex = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
    # Set current timestamp if not set
    params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

    # Generate the canonical query
    canonical_query_string = params.sort.collect do |k,v|
      [URI.escape(k.to_s, regex), URI.escape(v.to_s, regex)].join('=')
    end.join('&')

    # Generate the string to be signed
    string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"

    # Generate the signature required by the Product Advertising API
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), SECRET_KEY, string_to_sign)).strip()

    # Generate the signed URL
    request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
  end

  def self.by_asin(asin, response_group)
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemLookup",
      "AWSAccessKeyId" => ACCESS_KEY_ID,
      "AssociateTag" => ASSOCIATE_TAG,
      "ItemId" => asin,
      "IdType" => "ASIN",
      "ResponseGroup" => response_group
    }
    results = HTTParty.get(generate_request_url(params))
    results["ItemLookupResponse"]["Items"]["Item"]
  end

end