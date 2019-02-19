//
//  AttributedStringTests.swift
//  AttributedStringTests
//
//  Created by Indragie Karunaratne on 2/18/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import XCTest
@testable import AttributedString

#if os(macOS)
import AppKit
#else
import UIKit
#endif

class AttributedStringTests: XCTestCase {

    func testNSAttributedStringConcatenation() {
        let str1 = NSAttributedString(string: "Hello")
        let str2 = NSAttributedString(string: " World")
        let concatenated = str1 + str2
        XCTAssertEqual(NSAttributedString(string: "Hello World"), concatenated)
        XCTAssertFalse(concatenated === str1)
        XCTAssertFalse(concatenated === str2)
    }
    
    func testAttributedStringConcatenation() {
        let str1: AttributedString = "Hello"
        let str2: AttributedString = " World"
        let concatenated = str1 + str2
        XCTAssertEqual("Hello World", concatenated)
    }
    
    func testAttributedStringEquality() {
        let str1: AttributedString = "Hello"
        XCTAssertEqual("Hello", str1)
        XCTAssertNotEqual("World", str1)
    }

    func testApplyingStyleAttributesToEntireRangeOfNSMutableAttributedString() {
        let attrString = NSMutableAttributedString(string: "Hello World")
        attrString.style(withAttributes: [.color(.red), .underlineColor(.white)])
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(AttributedString.Color.white, attributes[.underlineColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: attrString.length), range)
    }
    
    func testApplyingStyleAttributesToPartialRangeOfNSMutableAttributedString() {
        let expectedRange = NSRange(location: 0, length: 5)
        let attrString = NSMutableAttributedString(string: "Hello World")
        attrString.style(withAttributes: [.color(.red)], range: expectedRange)
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(expectedRange, range)
    }
    
    func testCreateNewNSAttributedStringByApplyingAttributesToEntireRange() {
        let attrString = NSMutableAttributedString(string: "Hello World")
        let newAttrString = attrString.styled(withAttributes: [.color(.red)])
        XCTAssertFalse(attrString === newAttrString)
        
        var range = NSRange(location: 0, length: 0)
        let attributes = newAttrString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: newAttrString.length), range)
    }
    
    func testCreateNewNSAttributedStringByApplyingAttributesToPartialRange() {
        let expectedRange = NSRange(location: 6, length: 5)
        let attrString = NSMutableAttributedString(string: "Hello World")
        let newAttrString = attrString.styled(withAttributes: [.color(.red), .underlineColor(.white)], range: expectedRange)
        XCTAssertFalse(attrString === newAttrString)
        
        var range = NSRange(location: 0, length: 0)
        let attributes = newAttrString.attributes(at: 6, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(AttributedString.Color.white, attributes[.underlineColor] as! AttributedString.Color)
        XCTAssertEqual(expectedRange, range)
    }
    
    func testApplyingStyleAttributesToEntireRangeOfAttributedString() {
        var attrString: AttributedString = "Hello World"
        
        attrString.style(withAttributes: [.color(.red), .underlineColor(.white)])
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(AttributedString.Color.white, attributes[.underlineColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: attrString.nsAttributedString.length), range)
    }
    
    func testApplyingStyleAttributesToPartialRangeOfAttributedString() {
        var attrString: AttributedString = "Hello World"
        attrString.style(withAttributes: [.color(.red)], range: attrString.string.startIndex..<attrString.string.index(attrString.string.startIndex, offsetBy: 2))
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: 2), range)
    }
    
    func testCreateNewAttributedStringByApplyingAttributesToEntireRange() {
        let attrString: AttributedString = "Hello World"
        let newAttrString = attrString.styled(withAttributes: [.color(.red)])
        
        var range = NSRange(location: 0, length: 0)
        let attributes = newAttrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: newAttrString.nsAttributedString.length), range)
    }
    
    func testCreateNewAttributedStringByApplyingAttributesToPartialRange() {
        let attrString: AttributedString = "Hello World"
        let newAttrString = attrString.styled(withAttributes: [.color(.red), .underlineColor(.white)], range: attrString.string.index(attrString.string.startIndex, offsetBy: 3)..<attrString.string.index(attrString.string.startIndex, offsetBy: 6))
        
        var range = NSRange(location: 0, length: 0)
        let attributes = newAttrString.nsAttributedString.attributes(at: 3, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(AttributedString.Color.white, attributes[.underlineColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 3, length: 3), range)
    }
    
    func testStringInterpolationWithForegroundColorAttribute() {
        let attrString: AttributedString = "\("Hello", .red) World"
        
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(AttributedString.Color.red, attributes[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: 5), range)
    }
    
    func testStringInterpolationWithFontAttribute() {
        let font = AttributedString.Font.systemFont(ofSize: 10)
        let attrString: AttributedString = "\("Hello", font) World"
        
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(font, attributes[.font] as! AttributedString.Font)
        XCTAssertEqual(NSRange(location: 0, length: 5), range)
    }
    
    func testStringInterpolationWithTextAlignmentAttribute() {
        let attrString: AttributedString = "\("Hello", .center) World"
        
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        let paragraphStyle = attributes[.paragraphStyle] as! NSParagraphStyle
        XCTAssertEqual(.center, paragraphStyle.alignment)
        XCTAssertEqual(NSRange(location: 0, length: 5), range)
    }
    
    func testStringInterpolationWithLineBreakModeAttribute() {
        let attrString: AttributedString = "\("Hello", .byTruncatingTail) World"
        
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        let paragraphStyle = attributes[.paragraphStyle] as! NSParagraphStyle
        XCTAssertEqual(.byTruncatingTail, paragraphStyle.lineBreakMode)
        XCTAssertEqual(NSRange(location: 0, length: 5), range)
    }
    
    func testStringInterpolationWithWritingDirectionAttribute() {
        let attrString: AttributedString = "\("Hello", .rightToLeft) World"
        
        var range = NSRange(location: 0, length: 0)
        let attributes = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range)
        let paragraphStyle = attributes[.paragraphStyle] as! NSParagraphStyle
        XCTAssertEqual(.rightToLeft, paragraphStyle.baseWritingDirection)
        XCTAssertEqual(NSRange(location: 0, length: 5), range)
    }
    
    func testStringInterpolationWithMultipleStyledRanges() {
        let attrString: AttributedString = "\("Hello", .color(.red), .underlineColor(.white)) \("World", .color(.blue))"
        
        var range1 = NSRange(location: 0, length: 0)
        let attributes1 = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range1)
        XCTAssertEqual(AttributedString.Color.red, attributes1[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(AttributedString.Color.white, attributes1[.underlineColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: 5), range1)
        
        var range2 = NSRange(location: 0, length: 0)
        let attributes2 = attrString.nsAttributedString.attributes(at: 6, effectiveRange: &range2)
        XCTAssertEqual(AttributedString.Color.blue, attributes2[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 6, length: 5), range2)
    }
    
    func testStringInterpolationWithNestedStyledRanges() {
        let attrString: AttributedString = "\("Hello \("World", .blue)", .underlineColor(.white))"
        
        var range1 = NSRange(location: 0, length: 0)
        let attributes1 = attrString.nsAttributedString.attributes(at: 0, effectiveRange: &range1)
        XCTAssertEqual(AttributedString.Color.white, attributes1[.underlineColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 0, length: 6), range1)
        
        var range2 = NSRange(location: 0, length: 0)
        let attributes2 = attrString.nsAttributedString.attributes(at: 6, effectiveRange: &range2)
        XCTAssertEqual(AttributedString.Color.blue, attributes2[.foregroundColor] as! AttributedString.Color)
        XCTAssertEqual(NSRange(location: 6, length: 5), range2)
    }
}
