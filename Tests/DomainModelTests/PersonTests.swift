import XCTest
@testable import DomainModel

class PersonTests: XCTestCase {

    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }

    func testAgeRestrictions() {
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)

        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)

        matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(matt.spouse == nil)
    }

    func testAdultAgeRestrictions() {
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)

        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(mike.job != nil)

        mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(mike.spouse != nil)
    }
    
    func testSingleNamePersons() {
        let beyonce = Person(firstName: "Beyonce", age: 39)
        XCTAssert(beyonce.toString().contains("Beyonce"))
        
        let bono = Person(lastName: "Bono", age: 60)
        XCTAssert(bono.toString().contains("Bono"))
        
        let cher = Person(firstName: "Cher", age: 74)
        XCTAssert(cher.toString().contains("Cher"))
    }

    static var allTests = [
        ("testPerson", testPerson),
        ("testAgeRestrictions", testAgeRestrictions),
        ("testAdultAgeRestrictions", testAdultAgeRestrictions),
    ]
}

class FamilyTests : XCTestCase {
  
    func testFamily() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 1000)
    }

    func testFamilyWithKids() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))

        let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
        let _ = family.haveChild(mike)
        let _ = family.haveChild(matt)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 12000)
    }
  
    static var allTests = [
        ("testFamily", testFamily),
        ("testFamilyWithKids", testFamilyWithKids),
    ]
}
