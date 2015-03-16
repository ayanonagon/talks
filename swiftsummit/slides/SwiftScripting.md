# Swift **Scripting**
### Ayaka Nonaka
#### @ayanonagon

---

# **Designers**
# Engineers

---

# :moyai:

* Designer designs and exports assets

---

# :moyai:

* Designer designs and exports assets
* Upload to Dropbox or send over Slack

---

# :moyai:

* Designer designs and exports assets
* Upload to Dropbox or send over Slack
* Engineer adds to venmo-ios codebase

---

# :sob:

---

# :sob:

* So many Dropbox links & Slack messages, gets confusing

---

# :sob:

* So many Dropbox links & Slack messages, gets confusing
* Sometimes assets sizes are wrong

---

# :sob:

* So many Dropbox links & Slack messages, gets confusing
* Sometimes assets sizes are wrong
* No easy way to see all the assets in our app

---

# :bulb:

---

## pod 'venmo-ios-images'

---

# :bulb:

* Designer designs and exports assets

---

# :bulb:

* Designer designs and exports assets
* Designer makes pull-request to venmo-ios-images repo

---

# :bulb:

* Designer designs and exports assets
* Designer makes pull-request to venmo-ios-images repo
* Engineer reviews changes and merges

---
# :bulb:

* Designer designs and exports assets
* Designer makes pull-request to venmo-ios-images repo
* Engineer reviews changes and merges
* Engineer generates UIImage category for the new image(s)

---
# :bulb:

* Designer designs and exports assets
* Designer makes pull-request to venmo-ios-images repo
* Engineer reviews changes and merges
* Engineer generates UIImage category for the new image(s)
* pod update :rocket:

---

* Engineer generates UIImage category for the new image(s)

---

# We’re **LAZY**

---

# Automate all the things!

---

# **Script** all the things!

---

## Scripting

* Run from CLI
* Light-weight (no Xcode projects?)
* Tooling

---

# January 22nd, 2015

Ayaka Nonaka [11:07 AM]
ok time to write..... ruby? or.... swift?!

---

# January 22nd, 2015

Ayaka Nonaka [11:07 AM]
ok time to write..... ruby? or.... swift?!
actually not sure if i want to go down that path

---

# January 22nd, 2015

Ayaka Nonaka [11:07 AM]
ok time to write..... ruby? or.... swift?!
actually not sure if i want to go down that path
a 2 day long project is going to turn into like a 7 day long project lol

---

# January 22nd, 2015

Ayaka Nonaka [11:07 AM]
ok time to write..... ruby? or.... swift?!
actually not sure if i want to go down that path
a 2 day long project is going to turn into like a 7 day long project lol
i might look into swift though

---

# January 22nd, 2015

Ayaka Nonaka [11:07 AM]
ok time to write..... ruby? or.... swift?!
actually not sure if i want to go down that path
a 2 day long project is going to turn into like a 7 day long project lol
i might look into swift though
that might be kind of fun

---

# January 22nd, 2015

Eli Perkins [11:08 AM]
swift could be fun!

---

# :smirk:
# Challenge accepted

---

[snippet from venmo-image-assets script]

---

# Swift 
* familiar API’s
* “light” feeling language
* overly protective compiler is a caring compiler

---

## Reduce language dependencies

---

## Non “production” use

---

## Just another reason to write Swift

---

### chmod +x hello-world.swift

---

### xcrun swift hello-world.swift

---

### #!/usr/bin/env xcrun swift

---

### ./hello-world.swift

---

## dependency management?

---

# git submodules

* Simple, does very little.
* Maybe too little?

---

# CocoaPods

* Swift!
* Does dependency management.
* Relies on Xcode project.

---

# Carthage

* Swift!
* Does dependency management.
* Manually add framework to project.

---

# Cartfile

```
github "jdhealy/PrettyColors"
github "Alamofire/Alamofire"
```

---

# $ carthage bootstrap

```
*** No Cartfile.resolved found, updating dependencies
*** Fetching PrettyColors
*** Fetching Alamofire
*** Checking out Alamofire at "1.1.4"
*** Checking out PrettyColors at "v1.0.0"
*** xcodebuild output can be found in /var/folders/blah
*** Building scheme "Alamofire iOS" in Alamofire.xcworkspace
*** Building scheme "Alamofire OSX" in Alamofire.xcworkspace
*** Building scheme "PrettyColors iOS" in PrettyColors.xcodeproj
*** Building scheme "PrettyColors Mac" in PrettyColors.xcodeproj
```

---

```
➜  swiftsummit git:(master) ✗ ls Carthage/Build/iOS
Alamofire.framework    PrettyColors.framework
```

---

## /Library/Frameworks
## ?

---

```
➜  swiftsummit git:(master) ✗ swift -help
OVERVIEW: Swift compiler

USAGE: swift [options] <inputs>

OPTIONS:
  ...
  -F <value>             Add directory to framework search path
```

---

```
#!/usr/bin/env xcrun swift -F Carthage/Build/iOS
```

---

* jdhealy/PrettyColors
* thoughtbot/Argo
* kylef/CLIKit
* nomothetis/SemverKit
* ???

---

# ???
#### @ayanonagon

---
