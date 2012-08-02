require 'nokogiri'
require 'open-uri'
require 'mysql'
require 'rubygems'
require 'net/http'
require 'net/https'
require 'timeout'

def push_status(message,token,user     #token and user from pushover.net to send a notification with the current status

  http = Net::HTTP.new('api.pushover.net', 443)
  http.use_ssl = true
  path = '/1/messages.json'
  data = 'token='+token+'&user='+user+'&message= '+message

  headers = {'Content-Type'=> 'application/x-www-form-urlencoded'}

  resp, data = http.post(path, data, headers)
  puts "notification sent        "
end

def get_uscis_visa_status(receipt_num)    #receipt number case 13chars
  http = Net::HTTP.new('egov.uscis.gov', 443)
  http.use_ssl = true
  path = '/cris/Dashboard/CaseStatus.do'
  data = 'appReceiptNum='+receipt_num
  current=""
  headers = {'Content-Type'=> 'application/x-www-form-urlencoded'}

  resp, data = http.post(path, data, headers)
  doc=Nokogiri::HTML(resp.body)
  if(!doc.css('.results .current').first.nil?)
    updated_status= doc.css('.results .current a b').first.content.to_s
    token=''
    user=''
    push_status(updated_status,token,user) if updated_status!=current
  end
end



