ui 			= true

listener "tcp" {
  address 		= "0.0.0.0:8200"
  tls_cert_file   	= "/certs/fullchain.pem"
  tls_key_file    	= "/certs/privkey.pem"
  tls_min_version 	= "tls13"
  tls_max_version 	= "tls13"
}

api_addr = "https://0.0.0.0:8200"
