package fxgparser.parser.filters 
{
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	
	public class ColorMatrixFilter implements IFilter
	{
		
		public static var LOCALNAME:String = "ColorMatrixFilter";
		
		private var _matrix:Array = [ 1, 0, 0, 0, 0,
									  0, 1, 0, 0, 0,
									  0, 0, 1, 0, 0,
									  0, 0, 0, 1, 0 ];
		
		public function ColorMatrixFilter() { }
		
		public function parse( xml:XML ):void
		{
			var m:String = xml.@matrix.toString();
			_matrix = m.split( "," );
		}
		
		public function getFlashFilter():BitmapFilter 
		{
			return new flash.filters.ColorMatrixFilter( _matrix );
		}
		
	}

}