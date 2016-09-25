
require 'palo_alto/v6/config_parser'

describe "PaloAlto::V6::ConfigParser" do
  let(:config_parser) { PaloAlto::V6::ConfigParser.new}
  
  describe ".initialize" do
    it "returns a PaloAlto::V6:ConfigParser" do
      expect(config_parser).to be_instance_of(PaloAlto::V6::ConfigParser)
    end
  end
  
  describe ".parse" do
    describe "a simple policy" do
      let(:policy_text) { 'policy_name { from any; }' }
      
      before do
        @result = config_parser.parse(policy_text)
      end
      
      it "can parse a config with a single simple statement" do
        expect(@result).to_not be_nil
      end
      
      it "returns an array with a single element in it" do
        expect(@result).to be_instance_of(Array)
        expect(@result.length).to eq(1)
      end
      
      it "returns an array with a nat policy object" do
        expect(@result[0]).to be_instance_of(PaloAlto::Models::NatPolicy)
      end
      
      it "returns a nat policy object with the correct name" do
        expect(@result[0].name).to eq("policy_name")
      end
      
      it "returns a nat policy with the values from the config" do
        expect(@result[0].from).to eq("any")
      end
      
    end
    
    describe "parsing policy names" do
      it "handles names with spaces" do
        result = config_parser.parse('"policy name with spaces" { from any; }')
        expect(result[0].name).to eq("policy name with spaces")
      end
      
      it "handles names that start with an IP address" do
        result = config_parser.parse('10.182.4.117_NAT { from any; }')
        expect(result[0].name).to eq("10.182.4.117_NAT")
      end
      
    end
    
    describe "parsing policy attribute names" do
      it "translates key names with hyphens to underscores" do
        result = config_parser.parse('policy_name { nat-type ipv4; }')
        expect(result[0].nat_type).to eq("ipv4")
      end
    end
    
    describe "multiple policies" do
      let(:policy_text) {
        '
          policy_2 { 
            from any; 
          } 
          policy_1 {
            from trusted;
          }
          policy_3 {
            from untrusted;
          }
        '
      }
      
      before do
        @result = config_parser.parse(policy_text)
      end
      
      it "can parse a config with multiple simple policies in it" do
        expect(@result).to_not be_nil
      end
      
      it "returns an array with a single element in it" do
        expect(@result).to be_instance_of(Array)
        expect(@result.length).to eq(3)
      end
      
      it "returns the policies in the order specified in the config" do
        expect(@result[0].name).to eq("policy_2")
        expect(@result[1].name).to eq("policy_1")        
        expect(@result[2].name).to eq("policy_3")
      end
      
    end
    
    describe "config attributes" do
      it "parses multiple config attributes" do
        result = config_parser.parse('policy_name { from any; to trusted;}')
        expect(result[0].from).to eq('any')
        expect(result[0].to).to eq('trusted')
      end
      
      it "parses attributes with string values" do
        result = config_parser.parse('policy_name { translate-to "src: 123.45.67.89" ; }')
        expect(result[0].translate_to).to eq('src: 123.45.67.89')
      end

      it "parses attributes with IP values" do
        result = config_parser.parse('policy_name { destination 198.247.5.36; }')
        expect(result[0].destination).to eq('198.247.5.36')
      end

      it "parses attributes with IP values that include a netmask" do
        result = config_parser.parse('policy_name { destination 198.247.5.36/24; }')
        expect(result[0].destination).to eq('198.247.5.36/24')
      end
      
      it "parses attributes with aggregate interface values" do
        result = config_parser.parse('policy_name {  to-interface ae1.201 ; }')
        expect(result[0].to_interface).to eq('ae1.201')
      end
      
      it "parses attributes with arrays of IP addresses" do
        result = config_parser.parse('policy_name { source [ 10.185.4.0/23 10.179.4.0/23 10.182.4.0/23 ]; }')
        expect(result[0].source).to be_instance_of(Array)
        expect(result[0].source.length).to eq(3)
        expect(result[0].source[0]).to eq('10.185.4.0/23')
        expect(result[0].source[1]).to eq('10.179.4.0/23')
        expect(result[0].source[2]).to eq('10.182.4.0/23')
      end
      
      it "parses attributes with slash seperted lists of values" do
        result = config_parser.parse('policy_name { service  any1/any2/any3; }')
        expect(result[0].service).to be_instance_of(Array)
        expect(result[0].service.length).to eq(3)
        expect(result[0].service[0]).to eq('any1')
        expect(result[0].service[1]).to eq('any2')
        expect(result[0].service[2]).to eq('any3')
      end
      
      it "parses attributes that have no value" do
        result = config_parser.parse('policy_name { to  ; }')
        expect(result[0].to).to be_nil
      end
      
    end
    
    describe "error handling" do
      it "outputs an error for unrecognized characters" do
        expect {config_parser.parse('policy_name { # }') }.to output(/unrecognized character/).to_stdout
      end
    end
  end
  
end