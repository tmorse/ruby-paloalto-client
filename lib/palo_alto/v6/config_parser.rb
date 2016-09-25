
require 'rly'

require 'palo_alto/models/nat_policy'

module PaloAlto
  module V6
    class ConfigParser < Rly::Yacc
      
      rule 'policies : policies policy' do |policies_out, policies_in, policy|
        policies_out.value = policies_in.value.push( policy.value )
      end
     
      rule 'policies : ' do |policies_out|
        policies_out.value = []
      end
     
      rule 'policy : STRING "{" statements "}"
                   | IDENTIFIER "{" statements "}" ' do |policy, policy_name, open_brace, statements, close_brace|
        policy.value = PaloAlto::Models::NatPolicy.new(policy_name.value,statements.value)
      end
     
      rule 'statements : statements statement' do |statements_out, statements_in, statement|
        statements_out.value = statements_in.value.merge(statement.value)
      end
     
      rule 'statements : statement' do |statements_out, statement|
        statements_out.value = statement.value
      end
     
      rule 'statement : IDENTIFIER IDENTIFIER ";"
                        | IDENTIFIER STRING ";"
                        | IDENTIFIER IP_ADDRESS ";"
                        | IDENTIFIER AGGREGATE_INTERFACE ";"
                        | IDENTIFIER array ";"
                        | IDENTIFIER list ";"
                      ' do |st, key, value, semi|
        st.value = {key.value => value.value}
      end

      rule 'statement : IDENTIFIER ";" ' do |st, key|
        st.value = {key.value => nil}
      end

      rule 'array : "[" array_elements "]"' do |array_out, open_bracket, array_elements, close_bracket|
        array_out.value = array_elements.value
      end

      rule 'array_elements : array_elements array_element' do |array_out, array_in, element|
        array_out.value = array_in.value.push(element.value)
      end

      rule 'array_elements : array_element' do |array_out, element|
        array_out.value = [element.value]
      end

      rule 'array_element : IP_ADDRESS ' do |element_out, element|
        element_out.value = element.value
      end

      rule 'list : list "/" IDENTIFIER' do |list_out, list_in, forward_slash, element|
        list_out.value = list_in.value.push(element.value)
      end

      rule 'list : IDENTIFIER' do |list_out, element|
        list_out.value = [element.value]
      end

      lam = lambda {|x| puts "ERROR #{x}"}
      on_error(lam)

      lexer do
        ignore " \t\n"
        literals "{};[]/"

        token :AGGREGATE_INTERFACE, /ae\d+\.\d+/
        token :STRING, /\"([^\"]*)\"/ do |match|
          match.value = match.value[1..-2]
          match
        end
        token :IDENTIFIER, /[a-zA-Z][\w-]*/
        token :IDENTIFIER, /[\d][\d\.]*[a-zA-Z_-][\w-]+/  # catch identifiers that start out like IP addresses
        token :IP_ADDRESS, /(\d+)(\.\d+){3,3}(\/\d+)?/

        on_error do |t|
          puts "unrecognized character #{t.value}"
          t.lexer.pos += 1
          nil
        end
      end
    end
  end
end
