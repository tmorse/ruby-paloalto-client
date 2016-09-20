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
      end
    end
  end
end