package fxgparser.parser.style 
{
	import fxgparser.parser.utils.StyleUtil;
	
	public class RadialGradientStroke extends RadialGradient implements IStyleParser , IGradient, IStroke , IColor
	{
		
		public static var LOCALNAME:String = "RadialGradientStroke";
		
		protected var _stroke:SolidColorStroke;
		
		public function RadialGradientStroke() {}
		
		override public function parse( item:XML ):void 
		{
			_stroke = new SolidColorStroke();
			_stroke.parse( item );
			super.parse( item );
		}
		
		public function get weight():Number { return _stroke.weight; }
		public function get miterLimit():Number { return _stroke.miterLimit; }
		public function get caps():String { return _stroke.caps; }
		public function get joints():String { return _stroke.joints; }
		
		public function get color():uint { return _stroke.color; }
		public function get opacity():Number { return _stroke.opacity; }
	}

}