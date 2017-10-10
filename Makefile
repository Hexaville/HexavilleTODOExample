endpoint=${DYNAMODB_ENDPOINT}
table_name=hexaville_todo_example_session
repo=https://github.com/Hexaville/DynamodbSessionStore.git

define dynamodb_migrate
	git clone ${repo} || echo "Skip cloning"
	swift build --package-path ./DynamodbSessionStore
	./DynamodbSessionStore/.build/debug/dynamodb-session-store-table-manager create $(table_name) || echo "Skip migration"
endef

define dynamodb_migrate_with_specified_endpoint
	git clone ${repo} || echo "Skip cloning"
	swift build --package-path ./DynamodbSessionStore
	./DynamodbSessionStore/.build/debug/dynamodb-session-store-table-manager create --endpoint $(1) $(table_name) || echo "Skip migration"
endef

define print_success
	@echo Dynamodb Schema Migration is done.
	@echo
	@echo Building phase is successfully completed.
	@echo Please enter following command to start $(1) server
	@echo
	@echo .build/debug/hexaville-todo-example serve
	@echo
endef

all: release

debug:
	swift build
	@echo swift build is done
	@echo
ifeq ($(endpoint),)
	$(call dynamodb_migrate)
else
	$(call dynamodb_migrate_with_specified_endpoint, $(endpoint))
endif
	$(call print_success, debug)

release:
	swift build -c release
	@echo swift build is done
	@echo
ifeq ($(endpoint),)
	$(call dynamodb_migrate)
else
	$(call dynamodb_migrate_with_specified_endpoint, $(endpoint))
endif
	$(call print_success, release)

deploy:
	$(call dynamodb_migrate)
	hexaville deploy --hexavillefile ./Hexavillefile.production.yml HexavilleTODOExample
