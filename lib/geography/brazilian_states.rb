# encoding: utf-8
module Geography
  class BrazilianStates
    def self.states_codes
      states.map { |line| line.last }
    end

    def self.states
      [ [ "Acre", "AC" ],
        [ "Alagoas", "AL" ],
        [ "Amapá", "AP" ],
        [ "Amazonas", "AM" ],
        [ "Bahia", "BA" ],
        [ "Ceará", "CE" ],
        [ "Distrito Federal", "DF" ],
        [ "Espírito Santo", "ES" ],
        [ "Goiás", "GO" ],
        [ "Maranhão", "MA" ],
        [ "Mato Grosso", "MT" ],
        [ "Mato Grosso do Sul", "MS" ],
        [ "Minas Gerais", "MG" ],
        [ "Pará", "PA" ],
        [ "Paraíba", "PB" ],
        [ "Paraná", "PR" ],
        [ "Pernambuco", "PE" ],
        [ "Piauí", "PI" ],
        [ "Rio de Janeiro", "RJ" ],
        [ "Rio Grande do Sul", "RS" ],
        [ "Rio Grande do Norte", "RN" ],
        [ "Rondônia", "RO" ],
        [ "Roraima", "RR" ],
        [ "Santa Catarina", "SC" ],
        [ "São Paulo", "SP" ],
        [ "Sergipe", "SE" ],
        [ "Tocantins", "TO" ] ]
    end
  end
end
