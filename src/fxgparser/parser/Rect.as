package fxgparser.parser 
{
	import flash.display.*;
	import flash.geom.Point;
	import fxgparser.parser.abstract.AbstractPaint;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.utils.StyleUtil;
	
	public class Rect extends AbstractPaint implements IParser
	{
		public static var LOCALNAME:String = "Rect";
		
		public function Rect() { }
		
		private var _width:Number;
		private var _height:Number;
		
		private var _topLeftRadius:Point;
		private var _topRightRadius:Point;
		private var _bottomLeftRadius:Point;
		private var _bottomRightRadius:Point;
		
		public function parse( data:Data ):void 
		{
			var target:Shape = new Shape();
			var xml:XML = data.currentXml;
			var style:Style = new Style( xml );
			
			_width = style.width;
			_height = style.height;
			
			setCornerRadiuses( xml );
			
			paint( target , style );
			data.currentCanvas.addChild( target );
		}
		
		override protected function draw( graphics:Graphics ):void 
		{
			if ( isRounded )
				graphics.drawRoundRectComplex( 0, 0 , _width, _height, _topLeftRadius.x, _topRightRadius.x, _bottomLeftRadius.x, _bottomRightRadius.x );
			else
				graphics.drawRect( 0, 0, _width, _height );
		}
		
		private function setCornerRadiuses( item:XML ):void
		{
			if ( item.@radiusX.length() ) 
			{
				var radius:Point = getRadius( StyleUtil.toNumber( item.@radiusX ), StyleUtil.toNumber( item.@radiusY ) );
				_topLeftRadius = _topRightRadius = _bottomLeftRadius = _bottomRightRadius = radius.clone();
			}else
				_topLeftRadius = _topRightRadius = _bottomLeftRadius = _bottomRightRadius = new Point();
			
			if ( item.@topLeftRadiusX.length() ) 
				_topLeftRadius = getRadius( StyleUtil.toNumber( item.@topLeftRadiusX ), StyleUtil.toNumber( item.@topLeftRadiusY ) );
			if ( item.@topRightRadiusX.length() ) 
				_topRightRadius = getRadius( StyleUtil.toNumber( item.@topRightRadiusX ), StyleUtil.toNumber( item.@topRightRadiusY ) );
			if ( item.@bottomLeftRadiusX.length() ) 
				_bottomLeftRadius = getRadius( StyleUtil.toNumber( item.@bottomLeftRadiusX ), StyleUtil.toNumber( item.@bottomLeftRadiusY ) );
			if ( item.@bottomRightRadiusX.length() ) 
				_bottomRightRadius = getRadius( StyleUtil.toNumber( item.@bottomRightRadiusX ), StyleUtil.toNumber( item.@bottomRightRadiusY ) );
		}
		
		private function getRadius( radiusX:Number, radiusY:Number  ):Point
		{
			if ( !isNaN( radiusX ) && isNaN ( radiusY ) )
				return new Point( radiusX, radiusX ) ;
			if ( !isNaN( radiusX ) && !isNaN ( radiusY ) )
				return new Point( radiusX, radiusY ) ;
			return null;
		}
		
		private function get isRounded():Boolean
		{
			return ( _topLeftRadius || _topRightRadius || _bottomLeftRadius || _bottomRightRadius );
		}
	}

}