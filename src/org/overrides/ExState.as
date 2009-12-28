package org.overrides
{
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	
	import org.flixel.FlxState;

	public class ExState extends FlxState
	{
		public var the_world:b2World;
		protected var debug:Boolean;

		public function ExState()
		{
			super();
			
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(0.0, 0.0);
			environment.upperBound.Set(1000, 1000);//320.0, 240.0);
			var gravity:b2Vec2=new b2Vec2(0.0,80.0);
			
			the_world = new b2World(environment, gravity, true);
			debug = false;
		}
		
		public function init():void{
			
		}
		
		protected function initBox2DDebugRendering():void
		{
			if(debug){
				var debug_draw:b2DebugDraw = new b2DebugDraw();
				var debug_sprite:Sprite = new Sprite();
				addChild(debug_sprite);
				debug_draw.SetSprite(debug_sprite);
				debug_draw.SetDrawScale(1);
				debug_draw.SetAlpha(0.5);
				debug_draw.SetLineThickness(1);
				debug_draw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_centerOfMassBit);
				the_world.SetDebugDraw(debug_draw);
			}
		}
		
		override public function update():void
		{
			//the_world.Step(FlxG.elapsed, 10);
			the_world.Step(1/30, 10, 10);
			_layer.update();
		}
	}
}