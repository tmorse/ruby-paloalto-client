require "palo_alto/models/device"
require "palo_alto/models/virtual_system"

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

        node = doc.root

        p doc.to_xml
        #
        # p node.attributes
        # if node.name != "response"
        #   puts "ERROR, expected a result node but found #{node.name}"
        # end
        #
        # if node['status'] != "success"
        #   puts "ERROR,  result node not successful it was #{node['status']}"
        # end
        #
        # if node.elems.length != 1
        #   puts "ERROR, expected one child note for response node"
        # end
        #
        # node = node.elems[0]
        #
        # if node.name != "result"
        #   puts "ERROR, expected a result node but found #{node.name}"
        # end
        #
        #
        # if node.elems.length != 1
        #   puts "ERROR, expected one child node for result node"
        # end
        #
        # node = node.elems[0]
        #
        # if node.name != "member"
        #   puts "ERROR, expected a member node but found #{node.name}"
        # end
        
      end
    end
  end
end