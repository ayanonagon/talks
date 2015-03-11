#!/usr/bin/env xcrun swift -F Carthage/Build/iOS

import PrettyColors

let redText: String = Color.Wrap(foreground: .Red).wrap("Roses are red")
let blueText: String = Color.Wrap(foreground: .Blue).wrap("Violets are blue")
let blackText: String = Color.Wrap(foreground: .Black).wrap("But I can’t rhyme")
let moreBlueText: String = Color.Wrap(foreground: .Blue).wrap("So here’s more blue")

println(redText)
println(blueText)
println(blackText)
println(moreBlueText)
