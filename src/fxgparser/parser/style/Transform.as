package fxgparser.parser.style 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import fxgparser.parser.utils.GeomUtil;
	import fxgparser.parser.utils.StyleUtil;
	import fxgparser.parser.Constants;
	
	public class Transform
	{
		
		public var type:String;
		private var vals:Array;
		private var _matrix:Matrix;
		private var _colorTransform:ColorTransform;
		
		public function Transform( xml:XML = null ) 
		{
			if( xml != null ) parse( xml );
		}
		
		public function parse( xml:XML ):void 
		{
			var fxg:Namespace = Constants.fxg;
			if ( xml..fxg::Matrix.length() )
			{
				var m:XML = xml..fxg::Matrix[0];
				_matrix = new Matrix();
				StyleUtil.validateMatrix( m, _matrix );
			}
			
			if ( xml..fxg::ColorTransform.length() )
			{
				var ct:XML = xml..fxg::ColorTransform[0];
				_colorTransform = new ColorTransform();
				_colorTransform.redMultiplier = StyleUtil.validateAttr( ct.@redMultiplier, _colorTransform.redMultiplier);
				_colorTransform.greenMultiplier = StyleUtil.validateAttr(ct.@greenMultiplier,_colorTransform.greenMultiplier);
				_colorTransform.blueMultiplier = StyleUtil.validateAttr(ct.@blueMultiplier,_colorTransform.blueMultiplier);
				_colorTransform.alphaMultiplier = StyleUtil.validateAttr(ct.@alphaMultiplier, _colorTransform.alphaMultiplier);
				_colorTransform.redOffset = StyleUtil.validateAttr(ct.@redOffset,_colorTransform.redOffset);
				_colorTransform.greenOffset = StyleUtil.validateAttr(ct.@greenOffset,_colorTransform.greenOffset);
				_colorTransform.blueOffset = StyleUtil.validateAttr(ct.@blueOffset,_colorTransform.blueOffset);
				_colorTransform.alphaOffset = StyleUtil.validateAttr(ct.@alphaOffset, _colorTransform.alphaOffset);
			}
		}
		
		public function get matrix():Matrix { return _matrix; }
		public function get colorTransform():ColorTransform { return _colorTransform; }
		
		public function get hasMatrix():Boolean { return _matrix != null; }
		public function get hasColorTransform():Boolean { return _colorTransform != null; }
	}

}