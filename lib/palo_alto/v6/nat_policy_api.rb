require "palo_alto/models/nat_policy"
require 'palo_alto/v6/config_parser'

module PaloAlto
  module V6
    module NatPolicyApi
      # Parse out the nat_polices from a response to query for nat_policies
      #
      # == Returns
      #
      #  * +Array+ - Array of Models::Nat_Policy instances
      #
      # == Raises
      #
      #  * +Exception+ - Raises an exception if the request is unsuccessful
      def nat_policies
        options = {}
        options[:url]     = self.endpoint
        options[:method]  = :post
        options[:payload] = { type:   "op",
                              cmd:    "<show><running><nat-policy></nat-policy></running></show>",
                              key:    self.auth_key
                            }

        html_result = Helpers::Rest.make_request(options)
        
        doc = Nokogiri::XML(html_result)

        policy_text = doc.xpath("//response/result/member/text()").text
          
        parser = PaloAlto::V6::ConfigParser.new
        parser.parse(policy_text)

        # if node['status'] != "success"
        #   puts "ERROR,  result node not successful it was #{node['status']}"
        # end

     
      end
    end
  end
end