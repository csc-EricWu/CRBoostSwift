import UIKit

var str:String = "hello"

var range = str.index(str.startIndex, offsetBy: 1) ..< str.endIndex
print(str[range])

range = str.index(before: <#T##String.Index#>)
//range = ...< str.index(str.endIndex, offsetBy: -1)
//print(...< str.index(str.endIndex, offsetBy: -1))

//range = str.index(before: 1)
