﻿package PhysicsGame 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Controllers.b2Controller;
	
	import flash.events.Event;
	import common.Utilities;
	
	import org.overrides.ExSprite;
	import org.overrides.ExState;
	use namespace b2internal;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class Sensor extends ExSprite
	{
		[Embed(source = "../data/button.mp3")] private var SndTick:Class;
		
		protected var _events:Array;
		protected var _triggered:Boolean;
		//@desc Name of object that will trigger this sensor on collision.
		public var Trigger:String;
		
		public function Sensor(x:int=0, y:int=0, triggerName:String="Player")
		//(X:int=0, Y:int=0, Width:int=10, Height:int=10, triggerName:String="Player") 
		{
			super(x, y);
			name = "Sensor";
			//TODO:
			//super.width = Width;
			//super.height = Height;
			Trigger = triggerName;
			_triggered = false;
			//So only player collides with sensors. Without the if statements in SetImpactPoint() it'll still collide with world object that aren't assigned a category..
			fixtureDef.filter.maskBits = 0x0001;
			fixtureDef.isSensor = true;
			bodyDef.type = b2Body.b2_staticBody;
			
			initBoxShape();
			
			_events = new Array();
		}
		
		public function AddEvent(eventObj:EventObject):void
		{
			_events.push(eventObj);
		}
		
		/*
		override public function createPhysBody(world:b2World):void
		{
			super.createPhysBody(world);
			//final_body.SetStatic();
		}
		*/
		
		override public function update():void
		{
			super.update();
			
			if (_triggered)
			{
				playEvents();
			}
		}
		
		protected function playEvents():void
		{
			trace("Sensed by sensor.as");
			for each(var eventObj:EventObject in _events)
			{
				eventObj.activate();
			}
			_triggered = false;
		}
		
		override public function setImpactPoint(point:b2Contact):void {
			var spriteA:ExSprite = point.GetFixtureA().GetBody().GetUserData() as ExSprite;
			var spriteB:ExSprite = point.GetFixtureB().GetBody().GetUserData() as ExSprite;
			if ( spriteA.name == Trigger || spriteB.name == Trigger)
				_triggered = true;
		}
		
		override public function getXML():XML
		{
			var xml:XML = new XML(<sensor/>);
			xml.@x = x;		 		
			xml.@y = y;
			xml.@width = _bw;
			xml.@height = _bh;
			
			var eventXML:XML = new XML(<event/>);
			for each (var event:EventObject in _events){
				eventXML.@x = event.GetBody().GetWorldCenter().x * ExState.PHYS_SCALE;;
				eventXML.@y = event.GetBody().GetWorldCenter().y * ExState.PHYS_SCALE;;
				xml.appendChild(eventXML);
			}
			
			return xml;
		}
		
		override protected function onInitXMLComplete(xml:XML, world:b2World = null, controller:b2Controller = null, event:Event = null):void
		{
			//Load the bitmap data
			//if(event){
				//var loadinfo:LoaderInfo = LoaderInfo(event.target);
				//var bitmapData:BitmapData = Bitmap(loadinfo.content).bitmapData;
		 		//pixels = bitmapData;
			//}
			
			//Assume we have pixel data already....
			//imageResource = xml.file;
			//layer = xml.@layer;
			
			bodyDef.type = xml.@bodyType;
			
			_bw = xml.@width;
			_bh = xml.@height;
			
			initBoxShape();
			
			//bodyDef.angle = xml.@angle;
			bodyDef.position.Set(xml.@x/ExState.PHYS_SCALE, xml.@y/ExState.PHYS_SCALE);
			
			//TODO:Do we need to correct for x and y...?
			createPhysBody(world, controller);
			
			for each(var evXML:XML in xml.event){
				var t:b2Body = Utilities.GetBodyAtPoint(world, new b2Vec2(evXML.@x, evXML.@y), true);
				if(t)
		    		AddEvent(t.GetUserData());
		    }
			
			reset(xml.@x, xml.@y);
		}
	}
}