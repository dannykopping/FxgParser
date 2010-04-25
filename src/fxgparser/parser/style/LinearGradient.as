package fxgparser.parser.style
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import fxgparser.parser.style.IGradient;
	import fxgparser.parser.style.ColorType;
	import fxgparser.parser.utils.StyleUtil;
	import fxgparser.parser.utils.GeomUtil;
	import fxgparser.parser.Constants;
	import fxgparser.parser.style.ColorType;
	
	public class LinearGradient implements IStyleParser , IGradient
	{
		public static var LOCALNAME:String = "LinearGradient";
		
		public var id:String;
		
		protected var _type:String = GradientType.LINEAR;
		protected var _colors:Array = [];
		protected var _alphas:Array = [];
		protected var _ratios:Array = [];
		protected var _matrix:Matrix = new Matrix();
		protected var _method:String = SpreadMethod.PAD;
		
		protected var _x:Number;
		protected var _y:Number;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _rotation:Number;
		
		public function LinearGradient() { }
		
		public function parse( item:XML ):void 
		{
			_x = StyleUtil.toNumber( item.@x );
			_y = StyleUtil.toNumber( item.@y );
			_scaleX = StyleUtil.toNumber( item.@scaleX );
			_scaleY = item.@scaleY.length() ? StyleUtil.toNumber( item.@scaleY ) : _scaleX;
			_rotation = StyleUtil.toNumber( item.@rotation );
			
			var fxg:Namespace = Constants.fxg;
			
			createMatrix();
			if ( item..fxg::Matrix.length() )
			{
				var m:XML = item..fxg::Matrix[0];
				_matrix = new Matrix();
				StyleUtil.validateMatrix( m, _matrix );
			}
			
			var stops:XMLList = item.fxg::GradientEntry;
			for each( var stop:XML in stops ) 
				parseStop( stop );
		}
		
		public function setSize( rect:Rectangle ):void
		{
			if ( _scaleX == 0 && _scaleY == 0 )
			{
				_x = rect.x;
				_y = rect.y;
				_scaleX = rect.width;
				_scaleY = rect.height;
				createMatrix();
			}
		}
		
		protected function createMatrix():void
		{
			_matrix.createGradientBox( _scaleX, _scaleY );
			_matrix.rotate( GeomUtil.degree2radian( _rotation ) );
			_matrix.translate( _x , _y );
		}
		
		protected function parseStop( stop:XML ):void 
		{
			_colors.push( StyleUtil.toColor( stop.@color ));
			_alphas.push( stop.@alpha.length() ? StyleUtil.toNumber( stop.@alpha ) : 1.0 );
			_ratios.push( StyleUtil.toNumber( stop.@ratio ) * 255 );
		}
		
		public function get type():String { return _type; }
		public function get colors():Array { return _colors; }
		public function get alphas():Array { return _alphas; }
		public function get ratios():Array { return _ratios; }
		public function get matrix():Matrix { return _matrix; }
		public function get method():String { return _method; }
		
		public function get colorType():int { return ColorType.GRADIENT; }
	}
}