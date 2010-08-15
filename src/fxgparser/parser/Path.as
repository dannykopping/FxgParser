package fxgparser.parser 
{
	
	import flash.display.*;
	import fxgparser.parser.abstract.AbstractPaint;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.Constants;
	
	public class Path extends AbstractPaint implements IParser
	{
		
		public static var LOCALNAME:String = "Path";
		
		private var _commands:Vector.<int> = new Vector.<int>;
		private var _vertices:Vector.<Number> = new Vector.<Number>;
		private var _winding:String = 'evenOdd';
		
		public function Path() {}
		
		public function parse( data:Data ):void 
		{
			var target:Shape = new Shape();
			var style:Style = new Style( data.currentXml );
			
			if( data.currentXml.@winding.length() ) 
				_winding = data.currentXml.@winding;
				
			var d:String = data.currentXml.@data.toString();
			parsePath( d );
			
			style.width = getWidth();
			style.height = getHeight();
			
			paint( target , style  );
			data.currentCanvas.addChild( target );
		}
		
		override protected function draw( graphics:Graphics ):void 
		{
			graphics.drawPath( _commands, _vertices ,_winding );
		}
		
		protected function getWidth():Number 
		{
			var min:Number = 1000000;
			var max:Number = 0;
			var length:int = _vertices.length;
			for ( var i:int = 0; i < length; i += 2 ) {
				min = Math.min( _vertices[i] , min );
				max = Math.max( _vertices[i] , max );
			}
			return max - min;
		}
		
		protected function getHeight():Number 
		{
			var min:Number = 1000000;
			var max:Number = 0;
			var length:int = _vertices.length;
			for ( var i:int = 1; i < length; i += 2 ) {
				min = Math.min( _vertices[i] , min );
				max = Math.max( _vertices[i] , max );
			}
			return max - min;
		}
		
		private function parsePath( data:String ):void
		{
			var d:Array = data.match( /[MmZzLlHhVvCcSsQqTtAa]|-?[\d.]+/g );
			
			var len:int   = d.length;
			var pcm:String = ""; //pre command
			var px:Number = 0;  //pre x
			var py:Number = 0;  //pre y
			var sx:Number = 0;
			var sy:Number = 0;
			var px0:Number;
			var py0:Number;
			var cx:Number;
			var cy:Number;
			var cx0:Number;
			var cy0:Number;
			var x0:Number;
			var y0:Number;
			var rx:Number;
			var ry:Number;
			var rote:Number;
			var large:Boolean;
			var sweep:Boolean;
			
			for ( var i:int = 0; i < len; i++ )
			{
				var c:String = d[i];
				if ( c.charCodeAt(0) > 64 ) {
					pcm = c;
				}else {
					i--;
				}
				
				if( ( pcm == "M" || pcm == "m" )  && _commands.length > 0 && _commands[ _commands.length -1] == 1 )
					pcm = ( pcm == "M" ) ? "L" : "l";
				
				switch( pcm )
				{
					case "M":
						sx = px = Number( String(d[int(i + 1)]) );
						sy = py = Number( String(d[int(i + 2)]) );
						_commands.push( GraphicsPathCommand.MOVE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "m":
						sx = px += Number( String(d[int(i + 1)]) );
						sy = py += Number( String(d[int(i + 2)]) );
						_commands.push( GraphicsPathCommand.MOVE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "L":
						px = Number( String(d[int(i + 1)]) );
						py = Number( String(d[int(i + 2)]) );
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "l":
						px += Number( String(d[int(i + 1)]) );
						py += Number( String(d[int(i + 2)]) );
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( px, py );
						i += 2;
						break;
					case "H":
						px = Number( String(d[int(i + 1)]) );
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "h":
						px += Number( String(d[int(i + 1)]) );
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "V":
						py = Number( String(d[int(i + 1)]) );
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "v":
						py += Number( String(d[int(i + 1)]) );
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( px, py );
						i ++;
						break;
					case "C": //cubic bezier curve
						px0 = px;
						py0 = py;
						cx0 = Number( String(d[int(i + 1)]) );
						cy0 = Number( String(d[int(i + 2)]) );
						cx = Number( String(d[int(i + 3)]) );
						cy = Number( String(d[int(i + 4)]) );
						px = Number( String(d[int(i + 5)]) );
						py = Number( String(d[int(i + 6)]) );
						_bezier_curve(  px0, py0, cx0, cy0, cx, cy, px, py  );
						i += 6;
						break;
					case "c":
						px0 = px;
						py0 = py;
						cx0 = px + Number( String(d[int(i + 1)]) );
						cy0 = py + Number( String(d[int(i + 2)]) );
						cx = px + Number( String(d[int(i + 3)]) );
						cy = py + Number( String(d[int(i + 4)]) );
						px += Number( String(d[int(i + 5)]) );
						py += Number( String(d[int(i + 6)]) );
						_bezier_curve( px0, py0, cx0, cy0, cx, cy, px, py );
						i += 6;
						break;
					case "S": //short hand cubic bezier curve
						px0 = _vertices.length >= 2 ? _vertices[ _vertices.length -2 ] : px;
						py0 = _vertices.length >= 2 ? _vertices[ _vertices.length -1 ] : py;
						cx0 = px + px - cx;
						cy0 = py + py - cy;
						cx = Number( String(d[int(i + 1)]) );
						cy = Number( String(d[int(i + 2)]) );
						px = Number( String(d[int(i + 3)]) );
						py = Number( String(d[int(i + 4)]) );
						_bezier_curve( px0, py0 ,cx0, cy0, cx, cy, px, py );
						i += 4;
						break;
					case "s":
						px0 = _vertices.length >= 2 ? _vertices[ _vertices.length -2 ] : px;
						py0 = _vertices.length >= 2 ? _vertices[ _vertices.length -1 ] : py;
						cx0 = px + px - cx;
						cy0 = py + py - cy;
						cx = px + Number( String(d[int(i + 1)]) );
						cy = py + Number( String(d[int(i + 2)]) );
						px += Number( String(d[int(i + 3)]) );
						py += Number( String(d[int(i + 4)]) );
						_bezier_curve( px0, py0 , cx0, cy0, cx, cy, px, py  );
						i += 4;
						break;
					case "Q": //quadratic bezier curve
						cx = Number( String(d[int(i + 1)]) );
						cy = Number( String(d[int(i + 2)]) );
						px = Number( String(d[int(i + 3)]) );
						py = Number( String(d[int(i + 4)]) );
						_commands.push( GraphicsPathCommand.CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 4;
						break;
					case "q":
						cx = px + Number( String(d[int(i + 1)]) );
						cy = px + Number( String(d[int(i + 2)]) );
						px += Number( String(d[int(i + 3)]) );
						py += Number( String(d[int(i + 4)]) );
						_commands.push( GraphicsPathCommand.CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 4;
						break;
					case "T": //short hand quadratic bezier curve
						cx = 2*px - cx;;
						cy = 2*py - cy;
						px = Number( String(d[int(i + 1)]) );
						py = Number( String(d[int(i + 2)]) );
						_commands.push( GraphicsPathCommand.CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 2;
						break;
					case "t":
						cx = 2*px - cx;;
						cy = 2*py - cy;
						px += Number( String(d[int(i + 1)]) );
						py += Number( String(d[int(i + 2)]) );
						_commands.push( GraphicsPathCommand.CURVE_TO );
						_vertices.push( cx, cy, px, py );
						i += 2;
						break;
					case "A": //arc to
						x0    = px;
						y0    = py;
						rx    = Number( String(d[int(i + 1)]) );
						ry    = Number( String(d[int(i + 2)]) );
						rote  = Number( String(d[int(i + 3)]) )*Math.PI/180;
						large = ( String(d[int(i + 4)])=="1" );
						sweep = ( String(d[int(i + 5)])=="1" );
						px    = Number( String(d[int(i + 6)]) );
						py    = Number( String(d[int(i + 7)]) );
						__arc_curve( x0, y0, px, py, rx, ry, large, sweep, rote);
						i += 7;
						break;
					case "a": //arc to
						x0    = px;
						y0    = py;
						rx    = Number( String(d[int(i + 1)]) );
						ry    = Number( String(d[int(i + 2)]) );
						rote  = Number( String(d[int(i + 3)]) )*Math.PI/180;
						large = ( String(d[int(i + 4)])=="1" );
						sweep = ( String(d[int(i + 5)])=="1" );
						px   += Number( String(d[int(i + 6)]) );
						py   += Number( String(d[int(i + 7)]) );
						__arc_curve( x0, y0, px, py, rx, ry, large, sweep, rote );
						i += 7;
						break;
					case "Z":
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( sx, sy );
						break;
					case "z":
						_commands.push( GraphicsPathCommand.LINE_TO );
						_vertices.push( sx, sy );
						break;
					default:
						break;
				}
			}
		}
		
		private function _bezier_curve( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var k:Number = 1.0/ Constants.BEZIER_DETAIL;
			var t:Number = 0;
			var tp:Number;
			for ( var i:int = 1; i <= Constants.BEZIER_DETAIL; i++ )
			{
				t += k;
				tp = 1.0-t;
				_commands.push( GraphicsPathCommand.LINE_TO );
				_vertices.push( x0 * tp * tp * tp + 3 * cx0 * t * tp * tp + 3 * cx1 * t * t * tp + x * t * t * t , 
								y0 * tp * tp * tp + 3 * cy0 * t * tp * tp + 3 * cy1 * t * t * tp + y * t * t * t );
			}
		}
		
		private function __arc_curve( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number,
									large_arc_flag:Boolean, sweep_flag:Boolean, x_axis_rotation:Number ):void
		{			
			var e:Number  = rx/ry;
			var dx:Number = (x - x0)*0.5;
			var dy:Number = (y - y0)*0.5;
			var mx:Number = x0 + dx;
			var my:Number = y0 + dy;
			var rc:Number;
			var rs:Number;
			
			if( x_axis_rotation!=0 )
			{
				rc = Math.cos(-x_axis_rotation);
				rs = Math.sin( -x_axis_rotation);
				var dx_tmp:Number = dx*rc - dy*rs; 
				var dy_tmp:Number = dx*rs + dy*rc;
				dx = dx_tmp;
				dy = dy_tmp;
			}
			
			//transform to circle
			dy *= e;
			
			var len:Number = Math.sqrt( dx*dx + dy*dy );
			var begin:Number;
			
			if( len<rx )
			{
				//center coordinates the arc
				var a:Number  = ( large_arc_flag!=sweep_flag ) ? Math.acos( len/rx ) : -Math.acos( len/rx );
				var ca:Number = Math.tan( a );
				var cx:Number = -dy*ca;
				var cy:Number = dx*ca;
				
				//draw angle
				var mr:Number = Math.PI - 2 * a;
				
				//start angle
				begin = Math.atan2( -dy - cy, -dx - cx );
				
				//deformation back and draw
				cy /= e;
				rc  = Math.cos(x_axis_rotation);
				rs  = Math.sin(x_axis_rotation);
				__arc( mx + cx*rc - cy*rs, my + cx*rs + cy*rc, rx, ry, begin, (sweep_flag) ? begin+mr : begin-(2*Math.PI-mr), x_axis_rotation );
			}
			else
			{
				//half arc
				rx = len;
				ry = rx/e;
				begin = Math.atan2( -dy, -dx );
				__arc( mx, my, rx, ry, begin, (sweep_flag) ? begin+Math.PI : begin-Math.PI, x_axis_rotation );
			}
		}
		
		private function __arc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number ):void
		{
			var segmentNum:int = Math.ceil( Math.abs( 4*(end-begin)/Math.PI ) );
			var delta:Number   = (end - begin)/segmentNum;
			var ca:Number      = 1.0/Math.cos( delta*0.5 );
			var t:Number       = begin;
			var ctrl_t:Number  = begin - delta*0.5;
			var i:int;
			
			if( rotation==0 )
			{
				for( i=1 ; i<=segmentNum ; i++ )
				{
					t += delta;
					ctrl_t += delta;
					_commands.push( GraphicsPathCommand.CURVE_TO );
					_vertices.push( x + rx*ca*Math.cos(ctrl_t), y + ry*ca*Math.sin(ctrl_t), x + rx*Math.cos(t), y + ry*Math.sin(t) );
				}
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number;
				var yy:Number;
				var cxx:Number;
				var cyy:Number;
				for( i=1 ; i<=segmentNum ; i++ )
				{
					t += delta;
					ctrl_t += delta;
					xx  = rx*Math.cos(t);
					yy  = ry*Math.sin(t);
					cxx = rx*ca*Math.cos(ctrl_t);
					cyy = ry*ca*Math.sin(ctrl_t);
					_commands.push( GraphicsPathCommand.CURVE_TO );
					_vertices.push( x + cxx*rc - cyy*rs, y + cxx*rs + cyy*rc , x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				}
			}
		}
		
	}
	
}