# Swift **Scripting**
### Ayaka Nonaka
#### @ayanonagon

---

## swift in production app? :rocket:

---

# January 22nd, 2015

Ayaka Nonaka [11:07 AM]
ok time to write..... ruby? or.... swift?!
actually not sure if i want to go down that path
a 2 day long project is going to turn into like a 7 day long project lol
i might look into swift though that might be kind of fun

Eli Perkins [11:08 AM]
swift could be fun!

---

## Reduce language dependencies

---

## Non “production” use

---

## Just another reason to write Swift

---

[snippet from venmo-image-assets script]

---

# Scripting?

---

## Scripting

* Run from CLI
* Light-weight (no Xcode projects?)
* Tooling

---

### #!/usr/bin/env xcrun swift

---

### chmod +x hello.swift

---

### ./hello.swift

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
* another/example
* another/example

---

# ???
#### @ayanonagon

---
