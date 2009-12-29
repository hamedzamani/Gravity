package common
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;
	
	public class Utilities
	{
		public function Utilities()
		{
		}
		
		public static function GetBodyAtMouse(the_world:b2World, point:Point, includeStatic:Boolean=false):b2Body {
			var mousePVec:b2Vec2 = new b2Vec2();
			mousePVec.Set(point.x, point.y);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(point.x - 0.001, point.y - 0.001);
			aabb.upperBound.Set(point.x + 0.001, point.y + 0.001);
			var k_maxCount:int=10;
			var shapes:Array = new Array();
			var count:int=the_world.Query(aabb,shapes,k_maxCount);
			var body:b2Body=null;
			for (var i:int = 0; i < count; ++i) {
				if (shapes[i].GetBody().IsStatic()==false||includeStatic) {
					var tShape:b2Shape=shapes[i] as b2Shape;
					var inside:Boolean=tShape.TestPoint(tShape.GetBody().GetXForm(),mousePVec);
					if (inside) {
						body=tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
		
		/*
		public static function addJoint(the_world:b2World, body1:b2Body, body2:b2Body):void{
			var joint:b2DistanceJointDef = new b2DistanceJointDef();
			var body1:b2Body = _bodies[0] as b2Body;
			var body2:b2Body = _bodies[1] as b2Body;
			
			if(body1 && body2){
				joint.Initialize(body1, body2, body1.GetWorldCenter(), body2.GetWorldCenter());
				joint.collideConnected = true;
				_state.the_world.CreateJoint(joint);
				
				_bodies = new Array();
			}
		}*/


	}
}