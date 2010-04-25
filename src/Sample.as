package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.*;
	
	import fxgparser.FxgDisplay;
	

	public class Sample extends Sprite 
	{
		public var fxgurl:String = "fxg/fxgparser.fxg";
		public var fxgSprite:FxgDisplay;
		
		public function Sample():void 
		{
			var loader:URLLoader = new URLLoader( new URLRequest( fxgurl ) );
			loader.addEventListener( Event.COMPLETE , displayData );
		}
			
		private function displayData( e:Event ):void {
			var fxgxml:XML = XML( e.currentTarget.data );
			
			fxgSprite = new FxgDisplay( fxgxml );	//parse SVG
			
			addChild( fxgSprite );	
		}
	}
	
}