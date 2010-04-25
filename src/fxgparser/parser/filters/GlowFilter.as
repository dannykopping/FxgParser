package fxgparser.parser.filters 
{
	import flash.filters.BitmapFilter;
	import fxgparser.parser.Constants;
	import fxgparser.parser.utils.StyleUtil;
	
	public class GlowFilter implements IFilter
	{
		
		public static var LOCALNAME:String = "GlowFilter";
		
		private var _blurX:Number = 4;
		private var _blurY:Number = 4;
		private var _alpha:Number = 1;
		private var _color:uint = Constants.FILL_COLOR;
		private var _distance:Number = 4;
		private var _angle:Number = 45;
		private var _strength:Number = 1;
		private var _quality :Number = 1;
		private var _inner:Boolean = false;
		private var _knockout:Boolean = false;
		
		public function GlowFilter() { }
		
		public function parse( xml:XML ):void
		{
			_blurX = StyleUtil.validateAttr( xml.@blurX , _blurX );
			_blurY = StyleUtil.validateAttr( xml.@blurY , _blurY );
			_alpha = StyleUtil.validateAttr( xml.@alpha , _alpha );
			_distance = StyleUtil.validateAttr( xml.@distance , _distance );
			_angle = StyleUtil.validateAttr( xml.@angle , _angle );
			_strength = StyleUtil.validateAttr( xml.@strength , _strength );
			_quality = StyleUtil.validateAttr( xml.@quality , _quality );
			
			if ( xml.@color.length() ) _color = StyleUtil.toColor( xml.@color );
			if ( xml.@inner.length() ) _inner = xml.@inner.toString() == "true";
			if ( xml.@knockout.length() ) _knockout = xml.@knockout.toString() == "true";
		}
		
		public function getFlashFilter():BitmapFilter 
		{
			return new flash.filters.GlowFilter(_color, _alpha, _blurX, _blurY, _strength, _quality, _inner , _knockout  );
		}
		
	}

}