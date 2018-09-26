/*
 EDGE CASE
 - MULTI-FILE - inheritance, nesting, extensions
 - inherit from class that inherits from xctest
 - test cases declared in an extension
 - test functions declared in non xctest class
 - test declared in extension of class that isn't valid xctestcase

 - Nested Class/Struct/Extension Needs to Have `Nested.Class` for example

 NICE TO HAVE
 - remove existing allTests if it exists
 */

import SwiftSyntax
import Foundation

public func syntaxTesting() throws {
    try testGathering()
    try testFunctionGathering()
    try testClassGathering()

//    try testGathering()
//    try testSimple()
//    let file = "/Users/loganwright/Desktop/test/Tests/AppTests/TestCases.swift"
//    let url = URL(fileURLWithPath: file)
//    let sourceFile = try SyntaxTreeParser.parse(url)
//    let gatherer = TestFunctionGatherer()
//    gatherer.visit(sourceFile)
//    print(gatherer.testFunctions)
//    //    Visitor().visit(sourceFile)
//    //    TestFunctionLoader().visit(sourceFile)
//    print(sourceFile)
//    print("")
}

func testSimple() throws {
    let file = "/Users/loganwright/Desktop/test/Tests/AppTests/NestedClassTests.swift"
    let url = URL(fileURLWithPath: file)
    let sourceFile = try SyntaxTreeParser.parse(url)
    let gatherer = ClassGatherer()
    gatherer.visit(sourceFile)
    print("")
}

func testGathering() throws {
    let file = "/Users/loganwright/Desktop/test/Tests/AppTests/NestedClassTests.swift"
    let url = URL(fileURLWithPath: file)
    let sourceFile = try SyntaxTreeParser.parse(url)
    let gatherer = Gatherer()
    gatherer.visit(sourceFile)
    print("Found classes: ")
    print(try gatherer.classes.filter { $0.inheritsDirectlyFromXCTestCase }.map { try $0.flattenedName() }.joined(separator: "\n"))
    print("Found potential tests: ")
    print(gatherer.potentialTestFunctions.map { $0.identifier.text }.joined(separator: "\n"))
    print("")
}

// TODO: Temporary

func XCTAssert(_ bool: Bool, msg: String) {
    if bool { return }
    print(" [ERRROROROREOREOREOREORE] \(msg)")
}

func testClassGathering() throws {
    let file = "/Users/loganwright/Desktop/test/Tests/AppTests/NestedClassTests.swift"
    let url = URL(fileURLWithPath: file)
    let sourceFile = try SyntaxTreeParser.parse(url)
    let gatherer = Gatherer()
    gatherer.visit(sourceFile)
    let foundClasses = try gatherer.classes.map { try $0.flattenedName() }
    let expectation = [
        "A",
        "A.B",
        "A.C",
        "A.B.C",
        "D.C"
    ]
    XCTAssert(foundClasses == expectation, msg: "Parsing nested classes didn't work as expected.")
}

func testFunctionGathering() throws {
    let file = "/Users/loganwright/Desktop/test/Tests/AppTests/FunctionTestCases.swift"
    let url = URL(fileURLWithPath: file)
    let sourceFile = try SyntaxTreeParser.parse(url)
    let gatherer = Gatherer()
    gatherer.visit(sourceFile)
    print("Found classes: ")
    print(try gatherer.classes.map { try $0.flattenedName() }.joined(separator: "\n"))
    print("Found potential tests: ")
    print(gatherer.potentialTestFunctions.map { $0.identifier.text }.joined(separator: "\n"))
    print("")
}

func parseModule() {

}


/*
 ALL FUNCTIONS
 - FUNCTION NAME
 - PARENT NAME

 ALL CLASSES
 - NAME
 - INHERITANCE NAME
 // if XCTestCase.. ok, if not, see if class exists in our tree
 */

/*

 */

//struct TestClass {
//    let parentClass: String
//}
//struct TestFunction {
//    let parentClass: String
//    let functionName: String
//}

extension ClassDeclSyntax {
    var firstInheritance: String? {
        return inheritanceClause?
            .inheritedTypeCollection
            .first?
            .typeName
            .description
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var inheritsDirectlyFromXCTestCase: Bool {
        return firstInheritance == "XCTestCase"
    }
}

func buildInheritanceTree() {

}

extension FunctionDeclSyntax {
    var looksLikeTestFunction: Bool {
        guard
            // all tests MUST begin w/ 'test' as prefix
            identifier.text.hasPrefix("test"),
            // all tests MUST take NO arguments
            signature.input.parameterList.count == 0,
            // all tests MUST have no output
            signature.output == nil,
            // all tests MUST be declared w/in a class,
            // or an extension of a class
            nestedTree().containsClassOrExtension
            else { return false }
        return true
    }
}

extension Array where Element == Syntax {
    var containsClassOrExtension: Bool {
        return contains { $0 is ExtensionDeclSyntax || $0 is ClassDeclSyntax}
    }
}

extension Syntax {
    func nestedTree() -> [Syntax] {
        guard let parent = parent else { return [self] }
        return [self] + parent.nestedTree()
    }

    func countParents() -> Int {
        guard let parent = self.parent else { return 0 }
        return parent.countParents() + 1
    }

    func typedTree() -> [Syntax.Type] {
        guard let parent = self.parent else { return [type(of: self)] }
        return [type(of: parent)] + parent.typedTree()
    }
}

/*
 FILE PARSE RESULTS
 CLASS:
    - Name
    - InheritedFrom
    - ValidTestCases: [FUNCTION]
 FUNCTION:
    - Name
    - DeclaredWithin (Extension, Class)

 */

/*
 TEST RESULTS
 - class name
 - inheritance class
 • if XCTestCase – good to go
 • if class that inherits XCTest – good to go
 */

/*
 Is a class a testcase?
 - is it a class?
 - does it inherit XCTestCase
 */

struct Object {
    let name: String
    let inheritance: String?
}

class ClassGatherer: SyntaxVisitor {
    var testFunctions: [String] = []
    var classes: [ClassDeclSyntax] = []
    override func visit(_ node: ClassDeclSyntax) {
        print(node.identifier.text)
        let flattened = try! node.flattenedName()
        print(flattened)
        print("")
        super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) {
        guard node.looksLikeTestFunction else { return }
        testFunctions.append(node.identifier.text)
    }
}

class Gatherer: SyntaxVisitor {
    var classes: [ClassDeclSyntax] = []
    var potentialTestFunctions: [FunctionDeclSyntax] = []

    override func visit(_ node: ClassDeclSyntax) {
        classes.append(node)
        super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) {
        defer { super.visit(node) }
        guard node.looksLikeTestFunction else { return }
        potentialTestFunctions.append(node)
    }
}

extension Gatherer {
    // WARN: Need to use strings, not ClassDeclSyntax objects
    // because in other files, they are not directly linked
    func directXCTestInheritors() -> [ClassDeclSyntax] {
        fatalError("")
    }
}

protocol TypeDeclSyntax {
    var identifier: TokenSyntax { get }
}
extension ClassDeclSyntax: TypeDeclSyntax {}
extension EnumDeclSyntax: TypeDeclSyntax {}
extension StructDeclSyntax: TypeDeclSyntax {}
extension DeclSyntax where Self: TypeDeclSyntax {
    func flattenedName() throws -> String {
        if isNestedInTypeDecl {
            guard let outer = outerTypeDecl() else { throw "unable to find expected outer type decl" }
            return try outer.flattenedName() + "." + identifier.text
        }
        if isNestedInExtension {
            guard let outer = outerExtensionDecl() else { throw "unable to find outer class" }
            return outer.extendedType.description.trimmingCharacters(in: .whitespacesAndNewlines) + "." + identifier.text
        }
        return identifier.text
    }
}

extension DeclSyntax {
    var isNestedInExtension: Bool {
        return nestedTree().dropFirst().contains { $0 is ExtensionDeclSyntax }
    }

    var isNestedInClass: Bool {
        return nestedTree().dropFirst().contains { $0 is ClassDeclSyntax }
    }

    var isNestedInStruct: Bool {
        return nestedTree().dropFirst().contains { $0 is StructDeclSyntax }
    }

    var isNestedInEnum: Bool {
        return nestedTree().dropFirst().contains { $0 is EnumDeclSyntax }
    }

    var isNestedInTypeDecl: Bool {
        return nestedTree().dropFirst().contains { $0 is (DeclSyntax & TypeDeclSyntax) }
    }

    func outerClassDecl() -> ClassDeclSyntax? {
        return nestedTree().dropFirst().compactMap { $0 as? ClassDeclSyntax } .first
    }

    func outerStructDecl() -> StructDeclSyntax? {
        return nestedTree().dropFirst().compactMap { $0 as? StructDeclSyntax } .first
    }

    func outerExtensionDecl() -> ExtensionDeclSyntax? {
        return nestedTree().dropFirst().compactMap { $0 as? ExtensionDeclSyntax } .first
    }

    func outerEnumDecl() -> EnumDeclSyntax? {
        return nestedTree().dropFirst().compactMap { $0 as? EnumDeclSyntax } .first
    }

    func outerTypeDecl() -> (DeclSyntax & TypeDeclSyntax)? {
        return nestedTree().dropFirst().compactMap { $0 as? (DeclSyntax & TypeDeclSyntax) } .first
    }
}

class TestFunctionGatherer: SyntaxVisitor {

    var testFunctions: [String] = []

    override func visit(_ node: ClassDeclSyntax) {
        print(node.identifier.text)
        print("")
        let inheritance = node.inheritanceClause
        print(inheritance)
        let collection = inheritance?.inheritedTypeCollection
        var iterator = collection?.makeIterator()
        while let next = iterator?.next() {
            print(next.typeName)
            print("")
        }
        print(inheritance?.inheritedTypeCollection)

        print(node.inheritanceClause)
        print(node)
        print("")
        super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) {
        guard node.looksLikeTestFunction else { return }
        testFunctions.append(node.identifier.text)
    }
}

class Visitor: SyntaxVisitor {
    override func visit(_ node: FunctionDeclSyntax) {
        //        print("**\(#line): \(node)")
        print(node.identifier)
        print(node.signature)
        let sig = node.signature
        print(sig.input)
        print(sig.input.parameterList.count)
        print(sig.output)
        print(sig.throwsOrRethrowsKeyword)
        //        print(node.attributes)
        //        print(node.funcKeyword)
        //        print(node.)
        print("")
    }

    override func visit(_ node: FunctionParameterListSyntax) {
        print(node)
        print("")
    }

    //    override func visit(_ node: FunctionCallArgumentListSyntax) {
    //        print(node)
    //        print("")
    //    }
    //    override func visit(_ node: FunctionCallArgumentSyntax) {
    //        print(node)
    //        print("")
    //    }

    override func visit(_ node: FunctionSignatureSyntax) {
        //        print("**\(#line): \(node)")
    }
}

class TestFunctionLoader: SyntaxRewriter {
    var functions: [String] = []

    override func visit(_ token: TokenSyntax) -> Syntax {
        //        print("Got token: \(token)")
        //        print("Got type : \(token.tokenKind)")
        return token

    }
}