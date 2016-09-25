module PaloAlto
  module Models
    class NatPolicy
      attr_accessor :name, :destination, :from, :nat_type, :service, :source, :terminal, 
                    :to, :to_interface, :translate_to
  
      def initialize(name, params)
        @name = name
        params.each do |key, value|
          identifier = key.gsub(/-/,'_')
          public_send("#{identifier}=", value)
        end
      end
     
      def to_s
        str = "#{name}: {\n"
        str += "\tnat-type: #{nat_type}\n"
        str += "\tfrom: #{from}\n"
        str += "\tsource: #{source}\n"
        str += "\tto: #{to}\n"
        str += "\tto-interface: #{to_interface}\n"
        str += "\tdestination: #{destination}\n"
        str += "\tservice: #{service}\n"
        str += "\ttranslate-to: #{translate_to}\n"
        str += "\tterminal: #{terminal}\n"
        str += "}"
      end
    end
  end
end
