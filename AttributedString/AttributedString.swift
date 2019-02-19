//
//  AttributedString.swift
//  AttributedString
//
//  Created by Indragie Karunaratne on 2/18/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A wrapper for an `NSAttributedString` that adds typed attributes and
/// support for constructing attributed strings using string interpolation.
public struct AttributedString: ExpressibleByStringInterpolation, Equatable, Hashable {
    #if os(macOS)
    public typealias Color = NSColor
    public typealias Font = NSFont
    #else
    public typealias Color = UIColor
    public typealias Font = UIFont
    #endif
    
    public enum LigatureStyle: Int {
        case noLigatures = 0
        case defaultLigatures = 1
        case allLigatures = 2
    }
    
    public enum VerticalGlyphForm: Int {
        case horizontalText = 0
        case verticalText = 1
    }
    
    /// A single key/value pair for a text styling attribute.
    public enum Attribute {
        /// Use this attribute to change the font for a range of text.
        case font(Font)
        
        /// Use this attribute to apply multiple attributes to a range of text.
        /// If you do not specify this attribute, the string uses the default
        /// paragraph attributes, as returned by the defaultParagraphStyle method
        /// of NSParagraphStyle.
        case paragraphStyle(NSParagraphStyle)
        
        /// Use this attribute to specify the color of the text during rendering.
        /// If you do not specify this attribute, the text is rendered in black.
        case color(Color)
        
        /// Use this attribute to specify the color of the background area behind
        /// the text. If you do not specify this attribute, no background color
        /// is drawn.
        case backgroundColor(Color)
        
        /// Ligatures cause specific character combinations to be rendered using
        /// a single custom glyph that corresponds to those characters. The
        /// default value is `.defaultLigatures`
        case ligature(LigatureStyle)
        
        /// This value specifies the number of points by which to adjust kern-pair
        /// characters. Kerning prevents unwanted space from occurring between
        /// specific characters and depends on the font. The value 0 means kerning
        /// is disabled. The default value for this attribute is 0.
        case kern(Float)
        
        /// This value indicates whether the text has a line through it.
        case strikethroughStyle(NSUnderlineStyle)
        
        /// The color of the underline drawn through the text, as specified by
        /// `strikethroughStyle`
        case strikethroughColor(Color)
        
        /// This value indicates whether the text is underlined.
        case underlineStyle(NSUnderlineStyle)
        
        /// The color of the underline drawn on the text, as specified by
        /// `.underlineStyle`
        case underlineColor(Color)
        
        /// If it is not defined (which is the case by default), it is assumed
        /// to be the same as the foreground color otherwise, it describes the
        /// outline color
        case strokeColor(Color)
        
        /// This value represents the amount to change the stroke width and is
        /// specified as a percentage of the font point size. Specify 0 (the default)
        /// for no additional changes. Specify positive values to change the stroke
        /// width alone. Specify negative values to stroke and fill the text. For
        /// example, a typical value for outlined text would be 3.0
        case strokeWidth(Float)
        
        #if os(iOS) || os(macOS) || os(tvOS)
        /// For more information, see `NSShadow`
        case shadow(NSShadow)
        
        /// For more information, see `NSTextAttachment`
        case attachment(NSTextAttachment)
        #endif
        
        /// A text effect, such as `.letterpressStyle`
        case textEffect(NSAttributedString.TextEffectStyle)
        
        /// A link to open when the text range is tapped/cicked.
        case link(URL)
        
        /// Indicates the character’s offset from the baseline, in points.
        /// The default value is 0.
        case baselineOffset(Float)
        
        /// A floating point value indicating skew to be applied to glyphs.
        /// The default value is 0, indicating no skew.
        case obliqueness(Float)
        
        /// A floating point value indicating the log of the expansion factor
        /// to be applied to glyphs. The default value is 0, indicating no
        /// expansion.
        case expansion(Float)
        
        /// Represents the nested levels of writing direction overrides,
        /// in order from outermost to innermost.
        ///
        /// See: https://developer.apple.com/documentation/uikit/nswritingdirectionattributename?language=swift
        case writingDirection([Int])
        
        /// Controls layout orientation of text. In iOS, horizontal text is
        /// always used and specifying a different value is undefined.
        case verticalGlyphForm(VerticalGlyphForm)
        
        var keyValuePair: (NSAttributedString.Key, AnyObject) {
            switch self {
            #if os(iOS) || os(macOS) || os(tvOS)
            case .attachment(let attachment):
                return (.attachment, attachment)
            case .shadow(let shadow):
                return (.shadow, shadow)
            #endif
            case .backgroundColor(let backgroundColor):
                return (.backgroundColor, backgroundColor.cgColor)
            case .baselineOffset(let baselineOffset):
                return (.baselineOffset, baselineOffset as NSNumber)
            case .expansion(let expansion):
                return (.expansion, expansion as NSNumber)
            case .font(let font):
                return (.font, font)
            case .color(let foregroundColor):
                return (.foregroundColor, foregroundColor.cgColor)
            case .kern(let kern):
                return (.kern, kern as NSNumber)
            case .ligature(let ligature):
                return (.ligature, ligature.rawValue as NSNumber)
            case .link(let link):
                return (.link, link as NSURL)
            case .obliqueness(let obliqueness):
                return (.obliqueness, obliqueness as NSNumber)
            case .paragraphStyle(let paragraphStyle):
                return (.paragraphStyle, paragraphStyle)
            case .strikethroughColor(let strikethroughColor):
                return (.strikethroughColor, strikethroughColor.cgColor)
            case .strikethroughStyle(let strikethroughStyle):
                return (.strikethroughStyle, strikethroughStyle.rawValue as NSNumber)
            case .strokeColor(let strokeColor):
                return (.strokeColor, strokeColor.cgColor)
            case .strokeWidth(let strokeWidth):
                return (.strokeWidth, strokeWidth as NSNumber)
            case .textEffect(let textEffect):
                return (.textEffect, textEffect.rawValue as NSString)
            case .underlineColor(let underlineColor):
                return (.underlineColor, underlineColor.cgColor)
            case .underlineStyle(let underlineStyle):
                return (.underlineStyle, underlineStyle.rawValue as NSNumber)
            case .verticalGlyphForm(let verticalGlyphForm):
                return (.verticalGlyphForm, verticalGlyphForm.rawValue as NSNumber)
            case .writingDirection(let writingDirection):
                return (.writingDirection, writingDirection.map { $0 as NSNumber } as NSArray)
            }
        }
    }
    
    fileprivate var _attributedString: NSMutableAttributedString
    public var nsAttributedString: NSAttributedString {
        return _attributedString
    }
    
    fileprivate init(attributedString: NSAttributedString) {
        self._attributedString = attributedString.mutableCopy() as! NSMutableAttributedString
    }
    
    fileprivate init(noCopy attributedString: NSMutableAttributedString) {
        self._attributedString = attributedString
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: AttributedString, rhs: AttributedString) -> Bool {
        return lhs._attributedString == rhs._attributedString
    }
    
    // MARK: Hashable
    
    var hash: Int {
        return _attributedString.hashValue
    }
    
    // MARK: Operators
    
    /// Concatenates two attributed strings.
    ///
    /// - Parameters:
    ///   - lhs: The first attributed string.
    ///   - rhs: The second attributed string.
    /// - Returns: The concatenated attributed string.
    public static func +(lhs: AttributedString, rhs: AttributedString) -> AttributedString {
        let newAttributedString = lhs.nsAttributedString.mutableCopy() as! NSMutableAttributedString
        newAttributedString.append(rhs.nsAttributedString)
        return AttributedString(noCopy: newAttributedString)
    }
    
    // MARK: ExpressibleByStringLiteral
    
    public init(stringLiteral value: String) {
        self._attributedString = NSMutableAttributedString(string: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    // MARK: ExpressibleByStringInterpolation
    
    public init(stringInterpolation: StringInterpolation) {
        self._attributedString = stringInterpolation.attributedString
    }
    
    public struct StringInterpolation: StringInterpolationProtocol {
        fileprivate var attributedString: NSMutableAttributedString
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }
        
        public mutating func appendLiteral(_ literal: String) {
            self.attributedString.append(NSAttributedString(string: literal))
        }
        
        public mutating func appendInterpolation(_ string: AttributedString, _ attributes: Attribute...) {
            let range = NSRange(location: self.attributedString.length, length: string._attributedString.length)
            self.attributedString.append(string._attributedString)
            self.attributedString.style(withAttributes: attributes, range: range)
        }
        
        /// Appends a string styled by the specified foreground color.
        public mutating func appendInterpolation(_ string: AttributedString, _ color: Color) {
            self.appendInterpolation(string, .color(color))
        }
        
        /// Appends a string styled by the specified font.
        public mutating func appendInterpolation(_ string: AttributedString, _ font: Font) {
            self.appendInterpolation(string, .font(font))
        }
        
        #if os(iOS) || os(tvOS)
        /// Appends a string styled by the specified text style.
        public mutating func appendInterpolation(_ string: AttributedString, _ textStyle: UIFont.TextStyle) {
            self.appendInterpolation(string, .preferredFont(forTextStyle: textStyle))
        }
        
        /// Appends a string styled by the specified text style as determined
        /// by a provided trait collection.
        public mutating func appendInterpolation(_ string: AttributedString, _ textStyle: UIFont.TextStyle, traitCollection: UITraitCollection?) {
            self.appendInterpolation(string, .preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection))
        }
        #endif
        
        // Appends a string styled by the specified text alignment.
        public mutating func appendInterpolation(_ string: AttributedString, _ textAlignment: NSTextAlignment) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            self.appendInterpolation(string, .paragraphStyle(paragraphStyle))
        }
        
        // Appends a string styled by the specified line break mode.
        public mutating func appendInterpolation(_ string: AttributedString, _ lineBreakMode: NSLineBreakMode) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode
            self.appendInterpolation(string, .paragraphStyle(paragraphStyle))
        }
        
        // Appends a string styled by the specified writing direction.
        public mutating func appendInterpolation(_ string: AttributedString, _ writingDirection: NSWritingDirection) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.baseWritingDirection = writingDirection
            self.appendInterpolation(string, .paragraphStyle(paragraphStyle))
        }
    }
}

/// Concatenates two attributed strings.
///
/// - Parameters:
///   - lhs: The first attributed string.
///   - rhs: The second attributed string.
/// - Returns: The concatenated attributed string.
public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let newAttributedString = lhs.mutableCopy() as! NSMutableAttributedString
    newAttributedString.append(rhs)
    return newAttributedString
}

public extension NSAttributedString {
    /// Creates a new attributed string by applying the specified style
    /// attributes to the receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    ///   - range: The range to apply the attributes to.
    /// - Returns: A new attributed string.
    func styled(byAttributes attributes: [AttributedString.Attribute], range: NSRange) -> NSAttributedString {
        let mutableAttrString = mutableCopy() as! NSMutableAttributedString
        mutableAttrString.style(withAttributes: attributes, range: range)
        return mutableAttrString
    }
    
    /// Creates a new attributed string by applying the specified style
    /// attributes to the entire range of the receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    /// - Returns: A new attributed string.
    func styled(byAttributes attributes: [AttributedString.Attribute]) -> NSAttributedString {
        return styled(byAttributes: attributes, range: NSRange(location: 0, length: length))
    }
}

public extension NSMutableAttributedString {
    /// Applies the specified style attributes to the receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    ///   - range: The range to apply the attributes to.
    func style(withAttributes attributes: [AttributedString.Attribute], range: NSRange) {
        beginEditing()
        for attribute in attributes {
            let (key, value) = attribute.keyValuePair
            addAttribute(key, value: value, range: range)
        }
        endEditing()
    }
    
    /// Applies the specified style attributes to the entire range of the
    /// receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    ///   - range: The range to apply the attributes to.
    func style(withAttributes attributes: [AttributedString.Attribute]) {
        style(withAttributes: attributes, range: NSRange(location: 0, length: length))
    }
}

extension AttributedString {
    /// Applies the specified style attributes to the receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    ///   - range: The range to apply the attributes to.
    mutating func style(withAttributes attributes: [AttributedString.Attribute], range: Range<String.Index>) {
        _attributedString.style(withAttributes: attributes, range: NSRange(range, in: _attributedString.string))
    }
    
    /// Applies the specified style attributes to the entire range of the
    /// receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    ///   - range: The range to apply the attributes to.
    mutating func style(withAttributes attributes: [AttributedString.Attribute]) {
        _attributedString.style(withAttributes: attributes)
    }
    
    /// Creates a new attributed string by applying the specified style
    /// attributes to the receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    ///   - range: The range to apply the attributes to.
    /// - Returns: A new attributed string.
    func styled(byAttributes attributes: [AttributedString.Attribute], range: Range<String.Index>) -> AttributedString {
        var newAttributedString = AttributedString(attributedString: _attributedString)
        newAttributedString.style(withAttributes: attributes, range: range)
        return newAttributedString
    }
    
    /// Creates a new attributed string by applying the specified style
    /// attributes to the entire range of the receiver.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply.
    /// - Returns: A new attributed string.
    func styled(byAttributes attributes: [AttributedString.Attribute]) -> AttributedString {
        var newAttributedString = AttributedString(attributedString: _attributedString)
        newAttributedString.style(withAttributes: attributes)
        return newAttributedString
    }
}

