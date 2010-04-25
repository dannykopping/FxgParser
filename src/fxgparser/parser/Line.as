package fxgparser.parser 
{
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import fxgparser.parser.IParser;
	import fxgparser.parser.abstract.AbstractPaint;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.utils.StyleUtil;
	
	public class Line extends AbstractPaint implements IParser
	{
		
		public function Line() { }
		
		public static var LOCALNAME:String = "Line";
		
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;
		
		private var _commands:Vector.<int>;
		private var _vertices:Vector.<Number>;
		
		public function parse( data:Data ):void 
		{
			var target:Shape = new Shape();
			var style:Style = new Style( data.currentXml );
			
			_x1 = StyleUtil.toNumber( data.currentXml.@xFrom );
			_x2 = StyleUtil.toNumber( data.currentXml.@xTo  );
			_y1 = StyleUtil.toNumber( data.currentXml.@yFrom );
			_y2 = StyleUtil.toNumber( data.currentXml.@yTo  );
			
			_vertices = Vector.<Number>([ _x1, _y1 , _x2 , _y2 ]);
			_commands  = Vector.<int>([GraphicsPathCommand.MOVE_TO , GraphicsPathCommand.LINE_TO ]);
			
			paint( target, style );
			data.currentCanvas.addChild( target );
		}
		
		override protected function draw( graphics:Graphics ):void {
			graphics.drawPath( _commands, _vertices );
		}
		
	}

}