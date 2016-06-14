/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2014 Joseph Cloutier
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

#if macro

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

class ClassicFor {
	public static macro function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		
		for(field in fields) {
			switch(field.kind) {
				case FVar(t, e):
					field.kind = FVar(t, modifyExpr(e));
				case FProp(get, set, t, e):
					field.kind = FProp(get, set, t, modifyExpr(e));
				case FFun(f):
					f.expr = modifyExpr(f.expr);
			}
		}
		
		return fields;
	}
	
	private static function modifyExpr(expr:Expr):Expr {
		if(expr == null) {
			return null;
		}
		
		switch(expr.expr) {
			case EMeta(meta, block):
				if(meta.name == "for") {
					var params:Array<Expr> = meta.params;
					var init:Array<Expr>;
					var condition:Expr;
					var increment:Array<Expr>;
					
					if(params.length == 3) {
						init = [params[0]];
						condition = params[1];
						increment = [params[2]];
					} else {
						var i:Int = 0;
						while(i < params.length && isAssignment(params[i])) {
							i++;
						}
						
						init = params.slice(0, i);
						
						if(i < params.length) {
							condition = params[i];
						} else {
							//No valid condition was provided; default to true.
							condition = macro true;
						}
						
						increment = params.slice(i + 1);
					}
					
					return makeForLoop(init, condition, increment,
						ExprTools.map(block, modifyExpr));
				}
			default:
		}
		
		return ExprTools.map(expr, modifyExpr);
	}
	
	private static function isAssignment(expr:Expr):Bool {
		switch(expr.expr) {
			case EVars(_) | EBinop(OpAssign, _, _) | EBinop(OpAssignOp(_), _, _)
				| EUnop(OpDecrement, _, _) | EUnop(OpIncrement, _, _):
				return true;
			default:
				return false;
		}
	}
	
	private static function makeForLoop(init:Array<Expr>, condition:Expr, increment:Array<Expr>, block:Expr):Expr {
		var incrementExpr:Expr;
		if(increment.length == 1) {
			incrementExpr = increment[0];
		} else {
			incrementExpr = macro $b{increment};
		}
		
		init.push(macro while($condition) {
				var shouldBreak:Bool = true;
				do $block
				while(shouldBreak = false);
				if(shouldBreak) break;
				$incrementExpr;
			});
		
		return macro $b{init};
	}
}

#else

@:autoBuild(ClassicFor.build())
interface ClassicFor {
}

#end
