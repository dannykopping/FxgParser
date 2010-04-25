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
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		public function BitmapImage() {}
		
		public function parse( data:Data ):void 
		{
			var target:Shape = new Shape();
			var style:Style = new Style( data.currentXml );
			
			target.x = _x = StyleUtil.toNumber( data.currentXml.@x );
			target.y = _y = StyleUtil.toNumber( data.currentXml.@y );
			_width = style.width =  StyleUtil.validateAttr( data.currentXml.@width, _width );
			_height = style.height = StyleUtil.validateAttr( data.currentXml.@height, _height );
			
			if( data.currentXml.@scaleX.length() ) _width *= data.currentXml.@scaleX;
			if( data.currentXml.@scaleY.length() ) _height *= data.currentXml.@scaleY;
			
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