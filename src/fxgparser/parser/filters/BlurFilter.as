package fxgparser.parser.filters 
{
	import flash.filters.BitmapFilter;
	import fxgparser.parser.utils.StyleUtil;
	
	public class BlurFilter implements IFilter
	{
		
		public static var LOCALNAME:String = "BlurFilter";
		
		private var _blurX:Number = 4;
		private var _blurY:Number = 4;
		private var _quality :Number = 1;
		
		public function BlurFilter() { }
		
		public function parse( xml:XML ):void
		{
			_blurX = StyleUtil.validateAttr( xml.@blurX , _blurX );
			_blurY = StyleUtil.validateAttr( xml.@blurY , _blurY );
			_quality = StyleUtil.validateAttr( xml.@quality , _quality );

		}
		
		public function getFlashFilter():BitmapFilter 
		{
			return new flash.filters.BlurFilter( _blurX, _blurY, _quality );
		}
		
	}

}