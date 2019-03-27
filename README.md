# AttributedString.swift

This is a small Swift framework that uses Swift 5's [`ExpressibleByStringInterpolation`](https://nshipster.com/expressiblebystringinterpolation/) API to implement a more concise and type-safe way of defining attributed strings. Looking at a simple example, if you wanted to create an attributed string that has a partial range that is bolded, doing so with the typical `NSAttributedString` API would look like this:

```swift
let attrString = NSMutableAttributedString(string: "This is some text with a ");
let boldAttrString = NSAttributedString(string: "bold range", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
attrString.append(boldAttrString)
```
With `AttributedString.swift`, this becomes:

```swift
let attrString: AttributedString = "This is some text with a \("bold range", .boldSystemFont(ofSize: 20))"
```
Here's a more complex example with multiple ranges and multiple attributes:

```swift
let attrString: AttributedString = """
Things like \("the font", .boldSystemFont(ofSize: 20)) and \("the color", .red)
can be changed by simply specifying the respective attribute
value. More complex styles can be implemented
by \("combining multiple attributes", .color(.blue), .backgroundColor(.green), .underlineStyle(.single), .underlineColor(.black))
"""
```

The `AttributedString` type is a simple wrapper that can be converted to an `NSAttributedString` using the `attributedString` property. More detailed information can be found in the code documentation.

### Contact

* Indragie Karunaratne
* [@indragie](http://twitter.com/indragie)
* [http://indragie.com](http://indragie.com)

### License

AttributedString.swift is licensed under the MIT License. See `LICENSE` for more information.


