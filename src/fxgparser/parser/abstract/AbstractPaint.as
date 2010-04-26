package fxgparser.parser.abstract
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.*;
	import fxgparser.parser.Constants;
	
	public class AbstractPaint
	{
		public function AbstractPaint() {}
		
		protected function paint( target:Shape, style:Style ):void 
		{
			var itemRect:Rectangle = new Rectangle( style.x, style.y, style.width, style.height );
			
			if ( style.hasStroke  ) 
			{
				var stroke:IStroke = style.stroke as IStroke;
				target.graphics.lineStyle( 	stroke.weight , IColor( stroke ).color, IColor( stroke ).opacity, 
											Constants.LINE_PIXEL_HINTING, Constants.LINE_SCALE_MODE , 
											stroke.caps ,stroke.joints, stroke.miterLimit  );
			}
			if ( style.hasGradientStroke ) 
			{
				var sgrad:IGradient = style.stroke as IGradient;
				sgrad.setSize( itemRect );
				if( sgrad ) target.graphics.lineGradientStyle( 	sgrad.type, sgrad.colors, sgrad.alphas, 
																sgrad.ratios, sgrad.matrix , sgrad.method );
			}
		
			if ( style.hasFill ) 
			{
				var fill:IColor = style.fill as IColor;
				target.graphics.beginFill( fill.color , fill.opacity );
			}
			if ( style.hasGradientFill ) 
			{
				var grad:IGradient = style.fill as IGradient;
				grad.setSize( itemRect );
				if ( grad ) target.graphics.beginGradientFill( 	grad.type, grad.colors, grad.alphas , 
																grad.ratios , grad.matrix , grad.method  );
			}
			if ( style.hasBitmapFill )
			{
				var bfill:BitmapFill = style.fill as BitmapFill;
				if ( bfill.loading ) 
				{
					bfill.addEventListener( Event.COMPLETE , function( e:Event ):void { 
						paint( target , style );
						bfill.removeEventListener( Event.COMPLETE, arguments.callee );
					});
					return;
				}
				if ( bfill.bitmapdata )
				{
					bfill.setSize( itemRect );
					target.graphics.beginBitmapFill( bfill.bitmapdata, bfill.matrix , bfill.repeat );
				}
			}
			
			draw( target.graphics );	//draw graphics
			
			if ( style.hasFill || style.hasGradientFill || style.hasBitmapFill || style.hasStroke ) target.graphics.endFill();
			style.applyStyle( target );
		}
		
		protected function draw( graphics:Graphics ):void 
		{
			throw new Error( "AbstractPaint draw method" );
		}		
	}

}