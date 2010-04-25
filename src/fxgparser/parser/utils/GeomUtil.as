package fxgparser.parser.utils 
{
	import flash.geom.Point;
	
	public class GeomUtil
	{
		public static function getAngle(  pt1:Point , pt2:Point ):Number 
		{
			var dx:Number = pt2.x - pt1.x;
			var dy:Number = pt2.y - pt1.y;
			var angleRadian:Number = Math.atan2( dy , dx );
			return  angleRadian;
		}
		
		public static function getDistance( pt1:Point , pt2:Point ):Number 
		{
			var dx:Number = pt2.x - pt1.x;
			var dy:Number = pt2.y - pt1.y;
			return Math.sqrt( dx * dx + dy * dy );
		}
		
		public static function degree2radian( degree:Number ):Number {
			return degree * Math.PI / 180;
		}
		
	}

}