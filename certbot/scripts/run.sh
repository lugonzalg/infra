certbot certonly \
	--manual \
	--preferred-challenges=dns \
	--manual-auth-hook /scripts/auth.sh \
	--manual-cleanup-hook /scripts/cleanup.sh \
	-d ${DOMAIN} -d *.${DOMAIN}
