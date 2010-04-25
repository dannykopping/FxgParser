package fxgparser.parser.style
{
	import fxgparser.parser.utils.StyleUtil;
	
	public class SolidColorStroke extends SolidColor implements IStyleParser , IStroke
	{
		public static var LOCALNAME:String = "SolidColorStroke";
		
		private var _weight:Number;
		private var _miterLimit:Number;
		private var _caps:String;
		private var _joints:String;
		
		public function SolidColorStroke() {}
		
		override public function parse( item:XML ) :void
		{
			super.parse( item );
			
			_weight = StyleUtil.toNumber( item.@weight );
			_miterLimit = StyleUtil.toNumber( item.@miterLimit );
			_caps = item.@caps.toString();
			_joints = item.@joints.toString();
		}
		
		public function get weight():Number { return _weight; }
		public function get miterLimit():Number { return _miterLimit; }
		public function get caps():String { return _caps; }
		public function get joints():String { return _joints; }
	}

}