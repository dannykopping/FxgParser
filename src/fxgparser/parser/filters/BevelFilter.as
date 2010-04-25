package fxgparser.parser.filters 
{
	import flash.filters.BitmapFilter;
	import fxgparser.parser.Constants;
	import fxgparser.parser.utils.StyleUtil;
	
	public class BevelFilter implements IFilter
	{
		
		public static var LOCALNAME:String = "BevelFilter";
		
		private var _blurX:Number = 4;
		private var _blurY:Number = 4;
		private var _highlightAlpha:Number = 1;
		private var _highlightColor:uint = Constants.FILL_COLOR;
		private var _shadowAlpha:Number = 1;
		private var _shadowColor:uint = Constants.FILL_COLOR;
		private var _distance:Number = 4;
		private var _angle:Number = 45;
		private var _strength:Number = 1;
		private var _quality :Number = 1;
		private var _type :String = "inner";
		private var _knockout:Boolean = false;
		
		public function BevelFilter() { }
		
		public function parse( xml:XML ):void
		{
			if ( xml.@blurX.length() ) _blurX = xml.@blurX;
			if ( xml.@blurY.length() ) _blurY = xml.@blurY;
			if ( xml.@highlightAlpha.length() ) _highlightAlpha = xml.@highlightAlpha;
			if ( xml.@highlightColor.length() ) _highlightColor = StyleUtil.toColor( xml.@highlightColor );
			if ( xml.@shadowAlpha.length() ) _shadowAlpha = xml.@shadowAlpha;
			if ( xml.@shadowColor.length() ) _shadowColor = StyleUtil.toColor( xml.@shadowColor );
			if ( xml.@distance.length() ) _distance = xml.@distance;
			if ( xml.@angle.length() ) _angle = xml.@angle;
			if ( xml.@strength.length() ) _strength = xml.@strength;
			if ( xml.@quality.length() ) _quality = xml.@quality;
			if ( xml.@type.length() ) _type = xml.@type.toString();
			if ( xml.@knockout.length() ) _knockout = xml.@knockout.toString() == "true";
		}
		
		public function getFlashFilter():BitmapFilter 
		{
			return new flash.filters.BevelFilter(	 _distance, _angle, _highlightColor, _highlightAlpha, _shadowColor, _shadowAlpha, 
													_blurX, _blurY , _strength, _quality, _type, _knockout );
		}
		
	}

}