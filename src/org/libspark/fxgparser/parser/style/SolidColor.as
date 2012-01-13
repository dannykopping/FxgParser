package org.libspark.fxgparser.parser.style
{
	import org.libspark.fxgparser.parser.style.Style;
	import org.libspark.fxgparser.parser.utils.StyleUtil;
	import org.libspark.fxgparser.parser.Constants;
	
	public class SolidColor implements IStyleParser, IColor
	{
		public static var LOCALNAME:String = "SolidColor";
		
		protected var _color:uint = Constants.FILL_COLOR;
		protected var _opacity:Number = 1.0;

		public function SolidColor() {}
		
		public function parse( item:XML ) :void
		{
			_color = StyleUtil.toColor( item.@color );
			_opacity = StyleUtil.validateAttr( item.@alpha , _opacity );
		}
		
		public function get color():uint { return _color; }
		public function get opacity():Number { return _opacity; }
		
		public function get colorType():int { return ColorType.FLAT; }
	}

}