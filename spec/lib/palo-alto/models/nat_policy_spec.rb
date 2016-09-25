require "palo_alto/models/nat_policy"

describe "PaloAlto::Models::Device" do
  let(:name)            { "test-policy" }
  let(:params)          { {"destination" => "test destination",
                           "from" => "test from ", 
                           "nat_type" => "test nat type", 
                           "service" => "test service", 
                           "source" => "test source", 
                           "terminal" => "test terminal", 
                           "to" => "test to", 
                           "to_interface" => "test to interface", 
                           "translate_to" => "test translate to"
                        }}
  let(:ip)              { "2.2.2.2" }
  let(:virtual_systems) { [ "a", "b" ] }

  before do
    @nat_policy = PaloAlto::Models::NatPolicy.new(name, params)
  end

  describe ".initialize" do
    it "returns a PaloAlto::Models::NatPolicy instance" do
      expect(@nat_policy).to be_instance_of(PaloAlto::Models::NatPolicy)
    end
        

    it "assigns name" do
      expect(@nat_policy.name).to eq(name)
    end

    it "assigns all the params" do
      params.each do |key,value|
        expect(@nat_policy.public_send(key)).to eq(value)
      end
    end

    it "converts param keys with hyphens to underscores" do
      my_nat_policy = PaloAlto::Models::NatPolicy.new(name, {"to-interface" => "to-interface-test"})
      expect(my_nat_policy.to_interface).to eq("to-interface-test")
    end
    
  end
  
  describe ".to_s" do
    it "overrides to_s to provide a config like representation of the policy" do
      expect(@nat_policy.to_s).to match(/#{name}.*\{.*\}/m)
    end
    
    it "includes the params that were passed in" do
      policy_str = @nat_policy.to_s
      params.each_value do |value|
        expect(policy_str).to match(/#{value}/m)
      end      
    end
    
  end
end
