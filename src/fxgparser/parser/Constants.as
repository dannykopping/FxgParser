package fxgparser.parser 
{

	import flash.filters.BitmapFilterQuality;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontWeight;
	import flash.display.LineScaleMode;
	
	public class Constants
	{
		//namespaces
		public static const fxg:Namespace = new Namespace( "fxg", "http://ns.adobe.com/fxg/2008" );
		public static const d:Namespace = new Namespace( "d", "http://ns.adobe.com/fxg/2008/dt" );
		
		//Default Settings
		public static const FONT_FAMILY:String = "_sans";
		public static const FONT_SIZE:Number = 12;
		public static const FONT_WEIGHT:String = FontWeight.NORMAL;
		public static const FONT_LOOKUP:String = FontLookup.DEVICE;
		public static const FILL_COLOR:uint = 0x000000;
		public static const STROKE_COLOR:uint = 0x000000;
		public static const LINE_PIXEL_HINTING:Boolean = false;
		public static const LINE_SCALE_MODE:String = LineScaleMode.NONE;
		public static const BLUR_QUALITY:int = BitmapFilterQuality.HIGH;
		public static const BEZIER_DETAIL:uint = 20;

	}

}