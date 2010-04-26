package fxgparser.parser 
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.engine.*;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.elements.InlineGraphicElementStatus;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import flash.text.engine.FontLookup;
	import fxgparser.parser.utils.StyleUtil;
	import fxgparser.parser.Constants;

	public class TextGraphic implements IParser
	{
		public static var LOCALNAME:String = "TextGraphic";
		
		private var sprite:Sprite;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _textFlow:TextFlow;
		
		public function TextGraphic() {}
		
		public function parse( data:Data ):void 
		{
			sprite = new Sprite();
			sprite.name = data.currentXml.@id.toString();
			
			var style:Style = new Style( data.currentXml );
			
			var format:TextLayoutFormat = new TextLayoutFormat();
			
			format.fontFamily = StyleUtil.validateAttr( data.currentXml.@fontFamily , Constants.FONT_FAMILY );
			format.fontSize = StyleUtil.validateAttr( data.currentXml.@fontSize,Constants.FONT_SIZE );
			format.lineHeight = StyleUtil.validateAttr( data.currentXml.@lineHeight, format.lineHeight );
			format.color = StyleUtil.validateAttr( data.currentXml.@color, format.color );
			format.kerning = StyleUtil.validateAttr( data.currentXml.@kerning, format.kerning );
			format.whiteSpaceCollapse = StyleUtil.validateAttr( data.currentXml.@whiteSpaceCollapse, format.whiteSpaceCollapse );
			
			format.fontWeight = StyleUtil.validateAttr( data.currentXml.@fontWeight , format.fontWeight );
			format.fontStyle = StyleUtil.validateAttr( data.currentXml.@fontStyle, format.fontStyle );
			format.textDecoration = StyleUtil.validateAttr( data.currentXml.@textDecoration, format.textDecoration );
			format.lineThrough = StyleUtil.validateAttr( data.currentXml.@lineThrough, format.lineThrough );
			format.textAlpha = StyleUtil.validateAttr( data.currentXml.@textAlpha, format.textAlpha );
			format.backgroundAlpha = StyleUtil.validateAttr( data.currentXml.@backgroundAlpha, format.backgroundAlpha );
			format.baselineShift = StyleUtil.validateAttr( data.currentXml.@baselineShift, format.baselineShift );
			format.breakOpportunity = StyleUtil.validateAttr( data.currentXml.@breakOpportunity, format.breakOpportunity );
			format.digitCase = StyleUtil.validateAttr( data.currentXml.@digitCase, format.digitCase );
			format.digitWidth = StyleUtil.validateAttr( data.currentXml.@digitWidth, format.digitWidth );
			format.dominantBaseline = StyleUtil.validateAttr( data.currentXml.@dominantBaseline, format.dominantBaseline );
			format.ligatureLevel = StyleUtil.validateAttr( data.currentXml.@ligatureLevel, format.ligatureLevel );
			format.locale = StyleUtil.validateAttr( data.currentXml.@locale, format.locale );
			format.typographicCase = StyleUtil.validateAttr( data.currentXml.@typographicCase, format.typographicCase );
			format.textRotation = StyleUtil.validateAttr( data.currentXml.@textRotation, format.textRotation );
			format.trackingLeft  = StyleUtil.validateAttr( data.currentXml.@trackingLeft , format.trackingLeft );
			format.trackingRight  = StyleUtil.validateAttr( data.currentXml.@trackingRight , format.trackingRight );
			
			_width = style.width = StyleUtil.validateAttr(  data.currentXml.@width , NaN );
			_height = style.height = StyleUtil.validateAttr( data.currentXml.@height , NaN );

			var fxg:Namespace = Constants.fxg;
			var flowxml:XML = < TextFlow xmlns = "http://ns.adobe.com/textLayout/2008" /> ;
			var content:XML = data.currentXml..fxg::content[0].copy();
			if ( !content ) return;
			for each( var item:XML in content.descendants() )
				item.setNamespace( flowxml.namespace() );
			flowxml.appendChild( content.children() );
			
			_textFlow = TextConverter.importToFlow(  flowxml , TextConverter.TEXT_LAYOUT_FORMAT );
			_textFlow.hostFormat = format;
			_textFlow.flowComposer.addController( new ContainerController( sprite , _width , _height ) );
			_textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE , onImageLoaded );
			_textFlow.flowComposer.updateAllControllers();

			style.applyStyle( sprite );
			data.currentCanvas.addChild( sprite );
		}
		
		private function onImageLoaded( e:StatusChangeEvent ):void
		{
			if (e.status == InlineGraphicElementStatus.READY || e.status == InlineGraphicElementStatus.SIZE_PENDING)
				_textFlow.flowComposer.updateAllControllers();
		}
	}

}