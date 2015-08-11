import haxe.unit.*;

class Test extends TestCase implements ClassicFor {
    var dummy:Int;
    var dummy2(default, default):Int;
    var v:Int = {
        var sum = 0;
        @for(var i:Int = 0, i < 10, i++) {
            sum += i;
        }
        sum;
    };
    var p(default, never):Int = {
        var sum = 0;
        @for(var i:Int = 10, i > 0, i--) {
            sum += i;
        }
        sum;
    };

    function test_class_var() {
        assertEquals(45, v);
    }

    function test_class_prop() {
        assertEquals(55, p);
    }

    function test_add1To10() {
        var sum:Int = 0;

        @for(var i:Int = 1, i <= 10, i++) {
            sum += i;
        }

        assertEquals(55, sum);
    }

    static function main():Void {
        var runner = new TestRunner();
        runner.add(new Test());
        var success = runner.run();
        if (!success) {
            #if sys
            Sys.exit(1);
            #else
            throw "failed";
            #end
        }
    }
}