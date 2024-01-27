/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2014-2024 Joseph Cloutier
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

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using Lambda;

class ClassicFor {
	public static macro function build():Array<Field> {
		final fields:Array<Field> = Context.getBuildFields();
		
		for(field in fields) {
			switch(field.kind) {
				case FVar(t, e):
					field.kind = FVar(t, process(e));
				case FProp(get, set, t, e):
					field.kind = FProp(get, set, t, process(e));
				case FFun(f):
					f.expr = process(f.expr);
			}
		}
		
		return fields;
	}
	
	private static function process(expr:Expr):Expr {
		if(expr == null) {
			return null;
		}
		
		switch(expr.expr) {
			case EMeta({ name: "for", params: params, pos: pos }, body):
				var init:Array<Expr>;
				var condition:Expr;
				var increment:Array<Expr>;
				
				if(params.length == 3) {
					init = [params[0]];
					condition = params[1];
					increment = [params[2]];
				} else {
					var i:Int = params.findIndex(param -> param.expr.match(
						EBinop(OpEq | OpNotEq | OpGt | OpGte | OpLt | OpLte
							| OpBoolAnd | OpBoolOr | OpIn, _, _)
						| EUnop(OpNot, _, _) | EConst(_) | ECall(_, _)
						| EField(_, _) | EArray(_, _) | ETernary(_, _, _)
					));
					
					if(i >= 0) {
						init = params.slice(0, i);
						condition = params[i];
						increment = params.slice(i + 1);
					} else {
						i = params.findIndex(param -> !param.expr.match(EVars(_) | EBinop(OpAssign, _, _)));
						if(i < 0) {
							i = params.length;
						}
						
						init = params.slice(0, i);
						condition = macro true;
						increment = params.slice(i);
					}
				}
				
				increment.push(condition);
				
				final result:Array<Expr> = init;
				result.push(macro @:pos(pos) if($condition) {
					do
						${ body.map(process) }
					while($b{ increment });
				});
				return macro $b{ result };
			default:
		}
		
		return expr.map(process);
	}
}

#else

@:autoBuild(ClassicFor.build())
interface ClassicFor {
}

#end
