package fxgparser.parser 
{
	import flash.display.Shape;
	import flash.display.Graphics;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.abstract.AbstractPaint;
	import fxgparser.parser.utils.StyleUtil;
	import fxgparser.parser.style.BitmapFill;
	
	public class BitmapImage extends AbstractPaint implements IParser
	{
		public static var LOCALNAME:String = "BitmapImage";
		
		private var _width:Number;
		private var _height:Number;
		
		public function BitmapImage() {}
		
		public function parse( data:Data ):void 
		{
			var target:Shape = new Shape();
			var style:Style = new Style( data.currentXml );
			
			_width = style.width * style.scaleX;
			_height = style.height * style.scaleY;
			style.scaleX = style.scaleY = 1.0;
			
			var fill:BitmapFill = new BitmapFill();
			var fillxml:XML = data.currentXml.copy();
			delete fillxml.@x;
			delete fillxml.@y;
			delete fillxml.@rotation;
			fill.parse( fillxml );
			style.fill = fill;
			
			paint( target, style );
			data.currentCanvas.addChild( target );
		}
		
		override protected function draw( graphics:Graphics ):void {
			graphics.drawRect( 0, 0, _width, _height );
		}
		
	}

}