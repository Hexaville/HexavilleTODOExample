import SwiftAWSDynamodb
import Foundation

let dybamodb: Dynamodb
if let index = ProcessInfo.processInfo.arguments.index(of: "--endpoint") {
    let endpoint = ProcessInfo.processInfo.arguments[index+1]
    print("endpoint detected: \(endpoint)")
    
    dybamodb = Dynamodb(endpoint: endpoint)
} else {
    dybamodb = Dynamodb()
}

do {
    let input = Dynamodb.CreateTableInput(
        attributeDefinitions: [
            Dynamodb.AttributeDefinition(attributeType: .s, attributeName: "id")
        ],
        keySchema: [
            Dynamodb.KeySchemaElement(attributeName: "id", keyType: .hash)
        ],
        provisionedThroughput: Dynamodb.ProvisionedThroughput(
            writeCapacityUnits: Int64(10),
            readCapacityUnits: Int64(10)
        ),
        tableName: "hexaville_todo_app_example_todos"
    )
    
    _ = try dybamodb.createTable(input)
    print("created hexaville_todo_app_example_todos")
} catch {
    print(error)
}

do {
    let input = Dynamodb.CreateTableInput(
        attributeDefinitions: [
            Dynamodb.AttributeDefinition(attributeType: .s, attributeName: "id"),
        ],
        keySchema: [
            Dynamodb.KeySchemaElement(attributeName: "id", keyType: .hash),
        ],
        provisionedThroughput: Dynamodb.ProvisionedThroughput(
            writeCapacityUnits: Int64(10),
            readCapacityUnits: Int64(10)
        ),
        tableName: "hexaville_todo_app_example_users"
    )
    
    _ = try dybamodb.createTable(input)
    print("created hexaville_todo_app_example_users")
} catch {
    print(error)
}

print("done")
