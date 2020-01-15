set -eu
mongo -- "$MONGO_INITDB_DATABASE" <<-EOJS
	db.createUser({
		user: $(_js_escape "$MONGO_INITDB_ROOT_USERNAME"),
		pwd: $(_js_escape "$MONGO_INITDB_ROOT_PASSWORD"),
		roles: [ { role: 'dbOwner', db: $(_js_escape "$MONGO_INITDB_DATABASE") } ]
	})
EOJS