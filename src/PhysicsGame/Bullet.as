﻿package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Common.b2internal;
	
	import PhysicsGame.Components.PhysicsComponent;
	
	import org.flixel.FlxG;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	use namespace b2internal;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Bullet extends ExSprite
	{
		[Embed(source="../data/new_shot.png")] private var ImgBullet:Class;
		[Embed(source="../data/grav_pos2.mp3")] private var SndHit:Class;
		[Embed(source="../data/grav_pos1.mp3")] private var SndShoot:Class;
		
		protected var _gravityObject:GravityObject;
		private var _spawn:Boolean;
		private var spawnPos:b2Vec2;
		
		private static var count:uint = 0;
		
		//@desc Bullet constructor
		//@param world	We'll need this to spawn the bullet's physical body when it's shot.
		public function Bullet()
		{
			super();
			
			width = 8;
			loadGraphic(ImgBullet, true);
			
			name = "Bullet" + count;
			count++;
			
			exists = false;
			_spawn = false;
			spawnPos = new b2Vec2();
			
			//addAnimation("idle",[0, 1, 2, 3, 4, 5], 50);
			addAnimation("idle",[0], 50);
			//addAnimation("poof",[2, 3, 4], 50, false);
		}
		
		override public function update():void
		{
			loaded = physicsComponent.isLoaded();
			
			trace("bullet: " + x + ", " + y + " loaded: " + loaded);
			
			if(dead && finished){
				physicsComponent.destroyPhysBody();
				exists = false;
				if(_spawn){
					_spawn = false;
					_gravityObject.shoot(spawnPos.x * ExState.PHYS_SCALE, spawnPos.y * ExState.PHYS_SCALE, 0, 0);
				}
			}
			else { 
				//trace("bullet:" + name +  " x,y:" + x + "," + y);
				//trace("dead:" + dead + " finished: " + finished);
				super.update();
				
				//trace("bullet speed" + final_body.GetLinearVelocity().x + "," + final_body.GetLinearVelocity().y);
			}
		}
		
		override public function render():void
		{
			super.render();
		}
		
		override public function hurt(Damage:Number):void
		{
			if(dead) return;
			
			//Cannot create objects in hurt, this is called in collision....
			_spawn = true;
			
			GetBody().GetLinearVelocity().SetZero();
			if(onScreen()) FlxG.play(SndHit);
			dead = true;
			
			//play("poof");
		}
		
		public function killGravityObject():void 
		{
			_gravityObject.kill();
		}
		
		public function setGravityObject(gravityObject:GravityObject):void{
			_gravityObject = gravityObject;
		}

		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int, antiGravity:Boolean=false):void
		{
			//Reset x and y first because initBody uses object's location
			super.reset(X+width/2,Y+height/2);
			
			physicsComponent.setCategory(FilterData.PLAYER);
			physicsComponent.setMask(FilterData.PLAYER | FilterData.SPECIAL);
			physicsComponent.initBody(b2Body.b2_dynamicBody);
			physicsComponent.createFixture(b2Shape.e_circleShape, 1, 1);
			physicsComponent.final_body.SetBullet(true);
			physicsComponent.final_body.SetLinearVelocity(new b2Vec2(VelocityX, VelocityY));
			//.ApplyImpulse(new Box2D.Common.Math.b2Vec2(VelocityX,VelocityY), new Box2D.Common.Math.b2Vec2(x, y));
			
			play("idle");
			FlxG.play(SndShoot);
			
			//trace("bullet shoot");
			
			_gravityObject.antiGravity = antiGravity;
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			trace("bullet impact with something: " + oFixture.GetBody().GetUserData().name);
			trace("is it a sensor? " + oFixture.IsSensor());
			
			var worldManifold:b2WorldManifold = new b2WorldManifold();
			point.GetWorldManifold(worldManifold);
			
			if(worldManifold.m_points.length > 1){
				spawnPos = worldManifold.m_points[0];
			}
			
			hurt(0);
		}
	}
}