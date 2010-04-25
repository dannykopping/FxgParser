package fxgparser.parser.style
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import fxgparser.parser.utils.GeomUtil;
	
	public class RadialGradient extends LinearGradient implements IStyleParser , IGradient
	{
		public static var LOCALNAME:String = "RadialGradient";

		public function RadialGradient() {
			_type = GradientType.RADIAL;
		}
		
		override protected function createMatrix():void
		{
			_matrix.createGradientBox( _scaleX  , _scaleY );
			_matrix.translate( -_scaleX/2, -_scaleY/2 );
			_matrix.rotate( GeomUtil.degree2radian( _rotation ) );
			_matrix.translate( _x, _y );
		}
		
	}

}