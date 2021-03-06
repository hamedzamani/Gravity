package PhysicsGame
{
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	
	import ailab.*;
	import ailab.actions.*;
	import ailab.basic.*;
	import ailab.brains.*;
	import ailab.conditions.*;
	import ailab.decorators.*;
	import ailab.groups.*;
	
	import org.flixel.*;
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	
	public class Enemy extends ExSprite
	{
		[Embed(source="../data/g_walk_old.png")] private var ImgSpaceman:Class;
		
		private var brain:TaskTree;
		public var gFixture:b2Fixture;
		
		public function Enemy(x:int=0, y:int=0){
			super(x, y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			//Do this after to set graphics and shape first...
			width = 14;
			height = 30;
			
			physicsComponent.setCategory(FilterData.ENEMY);
			physicsComponent.initBody(b2Body.b2_dynamicBody);
			physicsComponent.addHead(0,1);
			physicsComponent.addTorso(0,1);
			gFixture = physicsComponent.addSensor(0.8, 1);
			loaded = true;
			
			name = "Enemy";
			
			damage = 10;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4, 5], 10);
			addAnimation("jump", [1]);
			//addAnimation("idle_up", [0]);
			//addAnimation("run_up", [6, 7, 8, 5], 12);
			//addAnimation("jump_up", [0]);
			//addAnimation("jump_down", [0]);

			//Working new brain
			brain = BrainFactory.createRandomBrain();//.createBrain(1);
			
			brain.blackboard.setObject("me", this);
			
			//This controls the speed of the enemy
			var _applyForce:b2Vec2 = new b2Vec2(4,0);
			brain.blackboard.setObject("force", _applyForce);
			
			brain.blackboard.setObject("canWalkForward", true);
		}
		
		override public function update():void
		{
			brain.update();
			
			super.update();
			
			//Not sure if this is used or is useful
			brain.blackboard.setObject("moving", GetBody().GetLinearVelocity().x > 0.1);
		}
		
		override public function render():void{
			super.render();
			
			drawGroundRayTrace();
		}
		
		override public function setImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.setImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				brain.blackboard.setObject("canJump", true);
			}
			else{
				brain.blackboard.setObject("blocked", true);
			}
		}
		
		override public function removeImpactPoint(point:b2Contact, myFixture:b2Fixture, oFixture:b2Fixture):void{
			super.removeImpactPoint(point, myFixture, oFixture);
			
			if(oFixture.IsSensor()) 
				return;
			
			if(myFixture == gFixture){
				brain.blackboard.setObject("canJump", false);
			}
			else{
				brain.blackboard.setObject("blocked", false);
			}
		}
		
		override public function getXML():XML{
			var xml:XML = new XML(<enemy/>);
			//xml.file =  imageResource;
			//xml.@layer = layer;
			//xml.@bodyType = GetBody().GetType();
			//xml.@shapeType = GetBody().GetFixtureList().GetType();
			//xml.@angle = angle;
			//xml.@friction = GetBody().GetFixtureList().GetFriction();
			//xml.@density = GetBody().GetFixtureList().GetDensity();
			//xml.@restitution = GetBody().GetFixtureList().GetRestitution();
			//xml.@damage = damage;
			//xml.@name = name;
			
			//XML representation is in screen coordinates, so scale up physics
			xml.@x = GetBody().GetPosition().x * ExState.PHYS_SCALE;
			xml.@y = GetBody().GetPosition().y * ExState.PHYS_SCALE;
					
			return xml;
		}
	}
}