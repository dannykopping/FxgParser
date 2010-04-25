package fxgparser.parser.style 
{
	import flash.display.DisplayObject;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.engine.FontWeight;
	import fxgparser.parser.FxgFactory;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.model.PersistentData;
	import fxgparser.parser.style.Transform;
	import fxgparser.parser.utils.StyleUtil;
	import fxgparser.parser.Constants;
	import fxgparser.parser.style.*;
	import fxgparser.parser.filters.*;
	
	public class Style
	{
		public var id:String = "item";
		
		public var display:Boolean = true;
		public var viewBox:Rectangle;
		public var visible:Boolean;
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number;
		public var height:Number;
		public var scaleX:Number = 1.0;
		public var scaleY:Number = 1.0;
		public var rotation:Number = 0;
		public var alpha:Number = 1.0;
		public var blendMode:String = BlendMode.NORMAL;
		
		//paint
		public var fill:IStyleParser;
		public var stroke:IStyleParser;
		
		public var maskType:*;
		public var scaleGridLeft:*;
		public var scaleGridRight:*;
		public var scaleGridTop:*;
		public var scaleGridBottom:*;
		
		public var transform:Transform;
		public var filters:Array = [];
		public var mask:XML;

		private var _xmls:XMLList = new XMLList();
		
		public function Style( xml:XML = null ) {
			if ( xml ) parse( xml );
		}
		
		public function parse( xml:XML ):void 
		{
			_xmls += xml;
			setAttr( xml );
			var attr:XMLList = xml.children();
			for each( var item:XML in attr )
				setStyle( item.localName() , item );
		}
		
		public function copy():Style {
			var style:Style = new Style();
			for each ( var xml:XML in _xmls ) style.addStyle( xml );
			return style;
		}
		
		public function addStyle( xml:XML ):void 
		{
			parse( xml );
		}
		
		public function applyStyle( d:DisplayObject , setName:Boolean = true  ):void {
			if( setName ) d.name = id;
			d.alpha = alpha;
			d.rotation = rotation;
			d.blendMode = blendMode;
			if ( viewBox ) d.scrollRect = viewBox;
			if ( hasMatrix ) d.transform.matrix = transform.matrix;
			if ( hasColorTransform ) d.transform.colorTransform = transform.colorTransform;
			if ( hasFilter ) d.filters = flashFilters;
			if ( hasMask ) {
				FxgFactory.parseData( new Data( mask, d.parent ) );
				var maskobj:DisplayObject =  d.parent.getChildAt( d.parent.numChildren -1 );
				if ( maskobj ) {
					var mtx:Matrix = maskobj.transform.matrix.clone();
					mtx.concat( getMatrix() );
					maskobj.transform.matrix = mtx;
					d.mask = maskobj;
				}
			}
		}
		
		public function getMatrix():Matrix 
		{	
			if ( hasMatrix )
				return transform.matrix;
			return new Matrix();
		}
		
		private function setAttr( item:XML ):void
		{
			x = StyleUtil.validateAttr( item.@x , x );
			y = StyleUtil.validateAttr( item.@y , y );
			width = StyleUtil.validateAttr( item.@width , width );
			height = StyleUtil.validateAttr( item.@height , height );
			alpha = StyleUtil.validateAttr( item.@alpha , alpha );
			scaleX = StyleUtil.validateAttr( item.@scaleX , scaleX);
			scaleX = StyleUtil.validateAttr( item.@scaleY , scaleY );
			rotation = StyleUtil.validateAttr( item.@rotation ,rotation );
			blendMode = StyleUtil.validateAttr(item.@blendMode , blendMode );
		}
		
		private function setStyle( key:String , item:XML ):void 
		{
			if ( key == null ) return;

			if ( key == "stroke" ) 
				stroke = getStyleFactory( item );
			else if ( key == "fill" ) 
				fill = getStyleFactory( item );
			else if ( key == "filters" )
			{
				var f:IFilter = getFilterFactory( item );
				if( f ) filters.push( f );
			}
			else if ( key == "transform" )
				transform = new Transform( item );
			else if ( key == "mask" ) 
				mask = item;
		}
		
		public function get hasStroke():Boolean 
		{ 
			return stroke != null && IStroke( stroke ).weight != 0 ; 
		}
		public function get hasGradientStroke():Boolean 
		{ 
			return hasStroke && stroke.colorType == ColorType.GRADIENT; 
		}
		
		public function get hasFill():Boolean 
		{ 
			return fill != null && fill.colorType == ColorType.FLAT; 
		}
		public function get hasGradientFill():Boolean 
		{ 
			return fill != null && fill.colorType == ColorType.GRADIENT;
		}
		public function get hasBitmapFill():Boolean 
		{ 
			return fill != null && fill.colorType == ColorType.BITMAP;
		}
		
		public function get hasFilter():Boolean 
		{ 
			return  filters.length > 0 ; 
		}
		public function get hasMatrix():Boolean 
		{ 
			return ( transform != null && transform.hasMatrix ); 
		}
		public function get hasColorTransform():Boolean 
		{ 
			return ( transform != null && transform.hasColorTransform ); 
		}
		public function get hasMask():Boolean 
		{ 
			return mask != null; 
		}
		
		public function get flashFilters():Array
		{
			if ( !hasFilter ) return [];
			var fs:Array = [];
			for each( var f:IFilter in filters )
				fs.push( f.getFlashFilter() );
			return fs;
		}
			
		//Color Style
		private static const COLORS:Array = [ 	SolidColor, SolidColorStroke, LinearGradient, BitmapFill, 
												RadialGradient, LinearGradientStroke , RadialGradientStroke ];
		
		private static function getStyleFactory( xml:XML ):IStyleParser 
		{
			var children:XMLList  = xml.children();
			for each( var child:XML in children )
			{
				var color:IStyleParser = getStyleParser( child );
				if ( !color ) continue;
				color.parse( child );
				return color;
			}
			return null;
		}
		
		private static function getStyleParser( xml:XML  ):IStyleParser 
		{
			for each( var Cl:Class in COLORS ) 
				if ( xml.localName() == Cl["LOCALNAME"] ) return new Cl();
			return null;
		}
		
		//Filter
		private static const FILTERS:Array = [ 	BlurFilter , DropShadowFilter, GlowFilter, BevelFilter , 
												ColorMatrixFilter , GradientBevelFilter , GradientGlowFilter ];
		
		private static function getFilterFactory( xml:XML ):IFilter 
		{
			var children:XMLList  = xml.children();
			for each( var child:XML in children )
			{
				var filter:IFilter = getFilterParser( child );
				if ( !filter ) continue;
				filter.parse( child );
				return filter;
			}
			return null;
		}
		
		private static function getFilterParser( xml:XML  ):IFilter 
		{
			for each( var Cl:Class in FILTERS ) 
				if ( xml.localName() == Cl["LOCALNAME"] ) return new Cl();
			return null;
		}
	}

}