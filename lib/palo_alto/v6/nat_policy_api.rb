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
        options[:payload] = { type:   "config",
                              action: "show",
                              key:    self.auth_key,
                              xpath:  "/config/devices" }

        html_result = Helpers::Rest.make_request(options)
      end
    end
  end
end