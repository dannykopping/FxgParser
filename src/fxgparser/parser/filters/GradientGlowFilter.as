package fxgparser.parser.filters 
{
	import flash.filters.BitmapFilter;
	import fxgparser.parser.Constants;
	import fxgparser.parser.utils.StyleUtil;
	
	public class GradientGlowFilter implements IFilter
	{
		
		public static var LOCALNAME:String = "GradientGlowFilter";
		
		private var _blurX:Number = 4;
		private var _blurY:Number = 4;
		private var _distance:Number = 4;
		private var _angle:Number = 45;
		private var _strength:Number = 1;
		private var _quality :Number = 1;
		private var _type :String = "inner";
		private var _knockout:Boolean = false;
		
		protected var _colors:Array = [];
		protected var _alphas:Array = [];
		protected var _ratios:Array = [];
		
		public function GradientGlowFilter() { }
		
		public function parse( xml:XML ):void
		{
			_blurX = StyleUtil.validateAttr( xml.@blurX , _blurX );
			_blurY = StyleUtil.validateAttr( xml.@blurY , _blurY );
			_distance = StyleUtil.validateAttr( xml.@distance , _distance );
			_angle = StyleUtil.validateAttr( xml.@angle , _angle );
			_strength = StyleUtil.validateAttr( xml.@strength , _strength );
			_quality = StyleUtil.validateAttr( xml.@quality , _quality );
			_type = StyleUtil.validateAttr( xml.@type , _type );
			
			if ( xml.@knockout.length() ) _knockout = xml.@knockout.toString() == "true";
			
			var fxg:Namespace = Constants.fxg;
			var stops:XMLList = xml.fxg::GradientEntry;
			for each( var stop:XML in stops ) 
				parseStop( stop );
		}
		
		public function getFlashFilter():BitmapFilter 
		{
			return new flash.filters.GradientGlowFilter(_distance, _angle, _colors, _alphas , _ratios, _blurX, _blurY , _strength, _quality, _type, _knockout );
		}
		
		protected function parseStop( stop:XML ):void 
		{
			_colors.push( StyleUtil.toColor( stop.@color ));
			_alphas.push( stop.@alpha.length() ? StyleUtil.toNumber( stop.@alpha ) : 1.0 );
			_ratios.push( StyleUtil.toNumber( stop.@ratio ) * 255 );
		}
		
	}

}