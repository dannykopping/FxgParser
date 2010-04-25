package fxgparser.parser.filters 
{
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	
	public class ColorMatrixFilter implements IFilter
	{
		
		public static var LOCALNAME:String = "ColorMatrixFilter";
		
		private var _matrix:Array = [];
		
		public function ColorMatrixFilter() { }
		
		public function parse( xml:XML ):void
		{
			var m:XML = xml..matrix[0];
			_matrix = [ m.@a, m.@b, m.@c, m.@d, m.@tx, m.@ty ];
		}
		
		public function getFlashFilter():BitmapFilter 
		{
			return new flash.filters.ColorMatrixFilter( _matrix );
		}
		
	}

}