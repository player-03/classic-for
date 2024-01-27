/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2015-2024 Andy Li, Joseph Cloutier
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

import utest.*;

class Test extends utest.Test implements ClassicFor {
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
		Assert.equals(45, variable);
	}
	
	private function testPropertyField():Void {
		Assert.equals(55, property);
	}
	
	private function testAddition():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			sum += i;
		}
		
		Assert.equals(45, sum);
	}
	
	private function testNoIterations():Void {
		var product:Int = 1;
		
		@for(var i:Int = 10, i < 10, i++) {
			product *= i;
		}
		
		Assert.equals(1, product);
	}
	
	private function testNoCondition():Void {
		var product:Int = 1;
		
		@for(var i:Int = 4, i++) {
			product *= i;
			if(product > 100) {
				break;
			}
		}
		
		Assert.equals(120, product);
	}
	
	private function testNoInit():Void {
		var product:Int = 1;
		var i:Int = 4;
		
		@for(i > 1, i--) {
			product *= i;
		}
		
		Assert.equals(24, product);
	}
	
	private function testNoIncrement():Void {
		var product:Int = 1;
		
		@for(var i:Int = 4, product < 16) {
			product *= i;
		}
		
		Assert.equals(16, product);
	}
	
	private function testFibonacci():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, var j:Int = 1, j < 10, i = j, j = sum) {
			sum = i + j;
		}
		
		Assert.equals(13, sum);
	}
	
	private function testBreak():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			if(i == 5) {
				break;
			}
			
			sum += i;
		}
		
		Assert.equals(10, sum);
	}
	
	private function testContinue():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			if(i == 5) {
				continue;
			}
			
			sum += i;
		}
		
		Assert.equals(40, sum);
	}
	
	private function testContinueAndBreak():Void {
		var sum:Int = 0;
		
		@for(var i:Int = 1, i < 10, i++) {
			if(i == 5) {
				continue;
			}
			if(i == 8) {
				break;
			}
			
			sum += i;
		}
		
		Assert.equals(23, sum);
	}
	
	public static function main():Void {
		UTest.run([new Test()]);
	}
}
