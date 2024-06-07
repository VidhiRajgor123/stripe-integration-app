class SoapClient
    def self.client
        Savon.client(wsdl: 'https://service-url?wsdl')
    end
end