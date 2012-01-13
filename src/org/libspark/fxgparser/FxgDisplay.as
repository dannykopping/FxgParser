package  org.libspark.fxgparser
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.libspark.fxgparser.parser.FxgFactory;
	
	public class FxgDisplay extends Sprite{
		
		private var _factory:FxgFactory;
		
		public function FxgDisplay( xml:XML = null) 
		{ 
			if( xml ) parse( xml );
		}
		
		public function parse( xml:XML ):void 
		{
			_factory = new FxgFactory();
			_factory.addEventListener( Event.COMPLETE, onComplete );
			_factory.parse(  xml  , this );
		}
		
		private function onComplete( e:Event ):void
		{
			dispatchEvent( e );
		}
		
	}
	
}