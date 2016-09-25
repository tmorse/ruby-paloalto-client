require "palo_alto/v6/nat_policy_api"
require "palo_alto/helpers/rest"
require "palo_alto/models/virtual_system"
require "nokogiri"

describe "PaloAlto::V6::NatPolicyApi" do
  # dummy class to demonstrate functionality
  class DummyClass
    extend PaloAlto::V6::NatPolicyApi

    def self.endpoint
      "https://some.host:80/api/"
    end

    def self.auth_key
      "OIGHOEIHT()*#Y"
    end
  end

  describe ".nat_policies" do

  end
end
