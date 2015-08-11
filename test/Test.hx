/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2015 Andy Li, Joseph Cloutier
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package;

import haxe.unit.*;

class Test extends TestCase implements ClassicFor {
	//Variables and properties must work even if they aren't initialized.
	private var emptyVariable:Int;
	private var emptyProperty(default, default):Int;
	
	private var variable:Int = {
		var sum = 0;
		@for(var i:Int = 0, i < 10, i++) {
			sum += i;
		}
		sum;
	};
	private var property(default, default):Int = {
		var sum = 0;
		@for(var i:Int = 10, i > 0, i--) {
			sum += i;
		}
		sum;
	};
	
	private function testVariableField():Void {
		assertEquals(variable, 45);
	}
	
	private function testPropertyField():Void {
		assertEquals(property, 55);
	}
	
	private function testAddition():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			sum += i;
		}
		
		assertEquals(sum, 45);
	}
	
	private function testNoIterations():Void {
		var product:Int = 1;
		
		@for(var i:Int = 10, i < 10, i++) {
			product *= i;
		}
		
		assertEquals(product, 1);
	}
	
	private function testNoInit():Void {
		var product:Int = 1;
		var i:Int = 4;
		
		@for(i > 1, i--) {
			product *= i;
		}
		
		assertEquals(product, 24);
	}
	
	private function testNoIncrement():Void {
		var product:Int = 1;
		
		@for(var i:Int = 4, product < 16) {
			product *= i;
		}
		
		assertEquals(product, 16);
	}
	
	private function testFibonacci():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, var j:Int = 1, j < 10, i = j, j = sum) {
			sum = i + j;
		}
		
		assertEquals(sum, 13);
	}
	
	private function testBreak():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			if(i == 5) {
				break;
			}
			
			sum += i;
		}
		
		assertEquals(sum, 10);
	}
	
	private function testContinue():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			if(i == 5) {
				continue;
			}
			
			sum += i;
		}
		
		assertEquals(sum, 40);
	}
	
	public static function main():Void {
		var runner = new TestRunner();
		runner.add(new Test());
		var success = runner.run();
		if(!success) {
			#if sys
				Sys.exit(1);
			#else
				throw "failed";
			#end
		}
	}
}
