endpoint=${DYNAMODB_ENDPOINT}
session_table_name=hexaville_todo_example_session
repo=https://github.com/Hexaville/DynamodbSessionStore.git

define dynamodb_migrate
	git clone ${repo} || echo "Skip cloning"
	swift build --package-path ./DynamodbSessionStore
	./DynamodbSessionStore/.build/debug/dynamodb-session-store-table-manager create $(session_table_name)
	./.build/$(1)/hexaville-todo-example-dynamodb-migrator
endef

define dynamodb_migrate_with_specified_endpoint
	git clone ${repo} || echo "Skip cloning"
	swift build --package-path ./DynamodbSessionStore
	./DynamodbSessionStore/.build/debug/dynamodb-session-store-table-manager create --endpoint $(1) $(session_table_name)
	./.build/$(2)/hexaville-todo-example-dynamodb-migrator
endef

define print_success
	@echo Dynamodb Schema Migration is done.
	@echo
	@echo Building phase is successfully completed.
	@echo Please enter following command to start server
	@echo
	@echo .build/$(1)/hexaville-todo-example serve
	@echo
endef

all: install

install:
	swift build
ifeq ($(endpoint),)
	$(call dynamodb_migrate,debug)
else
	$(call dynamodb_migrate_with_specified_endpoint,$(endpoint),debug)
endif
	$(call print_success,debug)

deploy:
	swift build
	$(call dynamodb_migrate,debug)
	hexaville deploy --hexavillefile ./Hexavillefile.production.yml hexaville-todo-example
