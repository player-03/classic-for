Classic "for"
=============

A library that enables C-style `for` loops within Haxe.

Usage
-----

```haxe
class Example implements ClassicFor {
    public static function add1To10():Int {
        var sum:Int = 0;
        
        @for(var i:Int = 1, i <= 10, i++) {
            sum += i;
        }
        
        return sum;
    }
}
```

To enable this feature in all of your classes at once, add the following command-line argument:

`--macro` [`addGlobalMetadata`](http://api.haxe.org//haxe/macro/Compiler.html#addGlobalMetadata)`("com.your.package.here", "@:build(ClassicFor.build())")`

In Lime/OpenFL, this would be one of the following:

```xml
<haxeflag name="--macro" value="addGlobalMetadata('com.your.package.here', '@:build(ClassicFor.build())')'" />
<haxeflag name="--macro" value="addGlobalMetadata('${APP_PACKAGE}', '@:build(ClassicFor.build())')'" />
```

In the former case, you have to type out your package name. The latter is more convenient, but it only works if you define your package using the `<meta />` tag, not the `<app />` tag.

Notes
-----

- Haxe does not allow semicolons between parentheses, so it is not possible to use the exact same syntax as C.
- If you provide exactly three loop arguments, the macro will treat the loop exactly like a `for` loop in C. Otherwise, it will be forced to guess what the arguments mean.
  - When guessing, the macro finds the first argument that is not an assignment operation or variable declaration. This will be considered the "loop condition."
  - Everything before the condition will be considered "initialization code," and everything afterwards will be considered "increment code."
  - If no condition is found, the loop will repeat endlessly. (Or until a `break` statement.)
