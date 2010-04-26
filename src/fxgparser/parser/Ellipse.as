package fxgparser.parser 
{

	import flash.display.Shape;
	import flash.display.Graphics;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.abstract.AbstractPaint;
	import fxgparser.parser.utils.StyleUtil;
	
	public class Ellipse extends AbstractPaint implements IParser
	{
		public static var LOCALNAME:String = "Ellipse";
		
		private var _rx:Number;
		private var _ry:Number;
		
		public function Ellipse() {	}
		
		public function parse( data:Data ):void 
		{
			var target:Shape = new Shape();
			var style:Style = new Style( data.currentXml );
			
			_rx = style.width  / 2;
			_ry = style.height / 2;

			paint( target, style );
			data.currentCanvas.addChild( target );
		}
		
		override protected function draw( graphics:Graphics ):void {
			graphics.drawEllipse( 0 , 0 , _rx * 2, _ry * 2 );
		}
		
	}

}