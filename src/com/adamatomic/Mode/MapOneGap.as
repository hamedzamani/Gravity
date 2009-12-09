﻿package com.adamatomic.Mode 
{
	import com.adamatomic.flixel.*;
	
	/**
	 * ...
	 * @author Norman
	 */
	public class MapOneGap extends MapBase
	{
		//Media content declarations
		[Embed(source="../../../data/Maps/MapCSV_OneGap_Background.txt", mimeType="application/octet-stream")] public var CSV_Background:Class;
		[Embed(source="../../../data/tiles_all.png")] public var Img_Background:Class;
		[Embed(source="../../../data/Maps/MapCSV_OneGap_Main.txt", mimeType="application/octet-stream")] public var CSV_Main:Class;
		[Embed(source="../../../data/tiles_all.png")] public var Img_Main:Class;
		[Embed(source="../../../data/Maps/MapCSV_OneGap_Foreground.txt", mimeType="application/octet-stream")] public var CSV_Foreground:Class;
		[Embed(source="../../../data/tiles_all.png")] public var Img_Foreground:Class;

		public function MapOneGap() {

			_setCustomValues();

			bgColor = 0xff000000;

			layerBackground = new FlxTilemap(new CSV_Background, Img_Background,1,1);
			layerBackground.x = 0;
			layerBackground.y = 0;
			layerBackground.scrollFactor.x = 1.000000;
			layerBackground.scrollFactor.y = 1.000000;
			layerMain = new FlxTilemap(new CSV_Main, Img_Main,3,1);
			layerMain.x = 0;
			layerMain.y = 0;
			layerMain.scrollFactor.x = 1.000000;
			layerMain.scrollFactor.y = 1.000000;
			layerForeground = new FlxTilemap(new CSV_Foreground, Img_Foreground,1,1);
			layerForeground.x = 0;
			layerForeground.y = 0;
			layerForeground.scrollFactor.x = 1.000000;
			layerForeground.scrollFactor.y = 1.000000;

			allLayers = [ layerBackground, layerMain, layerForeground ];

			mainLayer = layerMain;

			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 160;
			boundsMaxY = 80;
		}

		override public function customFunction(param:* = null):* {

		}

		private function _setCustomValues():void {
		}
		
	}

}