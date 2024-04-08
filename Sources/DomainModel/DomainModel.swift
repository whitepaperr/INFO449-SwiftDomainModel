import Foundation

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount: Int
    public var currency: String
    
    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: String) -> Money {
        let conversionRates = ["USD": 1.0, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
        let rateToUSD = 1 / (conversionRates[currency] ?? 1.0)
        let amountInUSD = Double(amount) * rateToUSD
        let rateFromUSD = conversionRates[to] ?? 1.0
        let convertedAmount = Int(round(amountInUSD * rateFromUSD))
        return Money(amount: convertedAmount, currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        if self.currency == to.currency {
            return Money(amount: self.amount + to.amount, currency: self.currency)
        } else {
            let converted = self.convert(to.currency)
            return Money(amount: converted.amount + to.amount, currency: to.currency)
        }
    }
    
    public func subtract(_ from: Money) -> Money {
        if self.currency == from.currency {
            return Money(amount: from.amount - self.amount, currency: self.currency)
        } else {
            let converted = self.convert(from.currency)
            return Money(amount: from.amount - converted.amount, currency: from.currency)
        }
    }
}


////////////////////////////////////
// Job
//
public class Job {
    public var title: String
    public var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome(_ hours: Int = 2000) -> Int {
        switch type {
        case .Hourly(let rate):
            return Int(Double(hours) * rate)
        case .Salary(let salary):
            return salary
        }
    }
    
    public func raise(byAmount: Int) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate + Double(byAmount))
        case .Salary(let salary):
            type = .Salary(salary + byAmount)
        }
    }
    
    public func raise(byAmount: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate + byAmount)
        case .Salary(let salary):
            type = .Salary(salary + Int(byAmount))
        }
    }
    
    public func raise(byPercent: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate * (1 + byPercent))
        case .Salary(let salary):
            type = .Salary(Int(Double(salary) * (1 + byPercent)))
        }
    }
}


////////////////////////////////////
// Person
//
public class Person {
    public var firstName: String?
    public var lastName: String?
    public var age: Int
    public var job: Job? {
        didSet {
            if age < 16 {
                job = oldValue
            }
        }
    }
    public var spouse: Person? {
        didSet {
            if age < 18 {
                spouse = oldValue
            }
        }
    }
    
    public init(firstName: String? = nil, lastName: String? = nil, age: Int) {
        assert(firstName != nil || lastName != nil, "At least one name must be provided.")
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    public func toString() -> String {
        let nameComponent = [firstName ?? "", lastName ?? ""].joined(separator: " ")
        let jobDescription = job?.title ?? "nil"
        let spouseName = spouse?.firstName ?? "nil"
        return "[Person: firstName:\(firstName ?? "nil") lastName:\(lastName ?? "nil") age:\(age) job:\(jobDescription) spouse:\(spouseName)]"
    }
}



////////////////////////////////////
// Family
//
public class Family {
    private var members: [Person]
    
    public init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }
    
    public func haveChild(_ child: Person) {
        if members.contains(where: { $0.age > 21 }) {
            members.append(child)
        }
    }
    
    public func householdIncome() -> Int {
        members.compactMap { $0.job?.calculateIncome() }.reduce(0, +)
    }
}
