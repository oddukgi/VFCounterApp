//
//  QueryTest.swift
//  VFCounterTests
//
//  Created by Sunmi on 2020/11/09.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import XCTest
@testable import CoreStore
@testable import VFCounter

class Category: CoreStoreObject {
       // MARK: Internal
   
   @Field.Stored("identifier", dynamicInitialValue: { UUID() })
   var identifier: UUID
   
   @Field.Stored("name",
                 customSetter: { object, field, newValue in
                   let fruits = [
                       "사과", "살구", "아보카도", "바나나", "블루베리", "체리",
                       "코코넛", "용과", "포도", "자몽", "아오리", "샤인머스캣",
                       "천도복숭아", "키위", "레몬", "망고", "망고스틴", "멜론",
                       "오렌지", "복숭아", "배", "감", "파인애플", "자두",
                       "석류", "라즈베리", "딸기", "귤", "수박"
                   ]
                   field.primitiveValue = newValue
                   if let newValue = newValue {
                       object.$type.value = fruits.contains(newValue) ? "과일" : "야채"
                   } else {
                       object.$type.value = nil
                   }
                 })
   
   var name: String?
   
   @Field.Stored("type")
   var type: String?

   @Field.Stored("amount")
   var amount: Int = 0
   
   @Field.Stored("date")
   var date: String?
   
   @Field.Stored("createdDate")
   var createdDate: Date?
   
   @Field.Stored("image")
   var image: Data?
   
   @Field.Stored("max")
   var max: Int = 0

}

class QueryTest: XCTestCase {

    @objc dynamic func testModelsCorrectOrNot() {
        let dataStack = DataStack(
           CoreStoreSchema(
               modelVersion: "V1",
               entities: [
                   Entity<Category>("Section")
               ],
               versionLock: [
                   "Section": [0x383f8045374e8b08, 0xa29659a170998a92, 0xb2ef550dc6ee8dee, 0x8892492b7a9a65de]
               ]
           )
       )
        
        self.prepareStack(dataStack, configurations: [nil]) { (stack) in
            let k1 = String(keyPath: \Category.$name)
            XCTAssertEqual(k1, "name")
            let k2 = String(keyPath: \Category.$type)
            XCTAssertEqual(k2, "type")
            
//            let updateDone = self.expectation(description: "update-done")
    
            stack.perform(
                asynchronous: { (transaction) in
                    let veggie = transaction.create(Into<Category>())
                    XCTAssertEqual(veggie.name, "오이")
                    XCTAssertTrue(type(of: veggie.type) == String.self)
                    XCTAssertEqual(veggie.createdDate, Date())
                    
                    for property in Category.metaProperties(includeSuperclasses: true) {
                        
                        switch property.keyPath {
                        
                        case String(keyPath: \Category.$date):
                            XCTAssertTrue(property is FieldContainer<Category>.Stored<Date>)
                            
                        case String(keyPath: \Category.$max):
                            XCTAssertTrue(property is FieldContainer<Category>.Stored<Int>)
                            
                        default:
                            XCTFail("Unknown KeyPath: \"\(property.keyPath)\"")
                        }
                    }
                    
                },
                success: { _ in

                    let person = try! stack.fetchOne(From<Category>())
                    XCTAssertNotNil(person)

                    let personPublisher = person!.asPublisher(in: stack)
                    XCTAssertEqual(personPublisher.$name, "오이")
                    XCTAssertEqual(personPublisher.$createdDate, Date())
                    XCTAssertEqual(personPublisher.$type, "야채")

                },
                failure: { _ in
                    
                    XCTFail()
                }
            
            )
        }
        
    }
    
    @nonobjc
    func prepareStack(_ dataStack: DataStack, configurations: [ModelConfiguration] = [nil], _ closure: (_ dataStack: DataStack) -> Void) {
        
        do {
            
            try configurations.forEach { (configuration) in
                
                try dataStack.addStorageAndWait(
                    SQLiteStore(
                        fileURL: SQLiteStore.defaultRootDirectory
                            .appendingPathComponent(UUID().uuidString)
                            .appendingPathComponent("\(Self.self)_\((configuration ?? "-null-")).sqlite"),
                        configuration: configuration,
                        localStorageOptions: .recreateStoreOnModelMismatch
                    )
                )
            }
        } catch let error as NSError {
            
            XCTFail(error.coreStoreDumpString)
        }
        closure(dataStack)
    }
    override class func setUp() {
     
    }
    
    override class func tearDown() {
        
    }

}
