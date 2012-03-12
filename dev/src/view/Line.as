package view 
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Line extends Sprite
		
	{
		private var line:Sprite = new Sprite();
		private var handler1:Sprite = new Sprite();
		private var handler2:Sprite = new Sprite();
		private var _xposition:int;
		private var _side:Boolean;
		private var _startPoint:Point;
		
		public function Line(xposition:int, side:Boolean, startPoint:Point, owner:Sprite) 
		{			
			_startPoint = startPoint;
			_side = side;
			_xposition = xposition;
			owner.addChild(this);
			addChild(line);
			addChild(handler1);
			addChild(handler2);
			createHandlers();
			
		}
		
		private function createHandlers():void 
		{
			handler1.graphics.beginFill(0x400000);
			handler1.graphics.drawRect( -2, -2, 5, 5); 
			handler1.addEventListener(MouseEvent.MOUSE_DOWN, onHandlerStartMove);
			handler1.x = _startPoint.x;
			handler1.y = _startPoint.y;
			handler2.graphics.beginFill(0x400000);
			handler2.graphics.drawRect( -2, -2, 5, 5); 				
			handler2.addEventListener(MouseEvent.MOUSE_DOWN, onHandlerStartMove);
			handler2.x = _startPoint.x + 40;
			handler2.y = _startPoint.y + 5;
			drawLine();
			
		}
		
		public function drawLine():void {
			var centralPoint:Point;
			var pt0:Point; var pt1:Point;
			if (Math.min(handler1.x, handler2.x) == handler1.x) {
				pt0 = new Point(handler1.x, handler1.y); 
				pt1= new Point(handler2.x, handler2.y); 
			} else {
				pt1 = new Point(handler1.x, handler1.y); 
				pt0= new Point(handler2.x, handler2.y); 
			}
			
			line.graphics.clear();
			changeLineStyle(1)
			var lastPoint:Point = pt0.clone();
			line.graphics.moveTo(pt0.x, pt0.y)
			var f1:Boolean = (pt0.x < _xposition)
			var f2:Boolean = (pt1.x < _xposition)
			if ( f1 != f2) {
				var pos:Number = (_xposition - pt0.x) / (pt1.x - pt0.x);
				centralPoint = Point.interpolate(new Point(pt1.x, pt1.y), new Point(pt0.x, pt0.y), pos);											
				drawLineStyled(true, lastPoint, centralPoint.clone());
				lastPoint = centralPoint.clone();
				changeLineStyle(2)
				drawLineStyled(false, lastPoint, pt1.clone());
			} else {
				drawLineStyled(f1, lastPoint, pt1);
			}
			//
		}
		
		private function drawLineStyled(side:Boolean, ptIni:Point, ptEnd:Point):void {
			trace("side", side);
			if (side) {
				line.graphics.lineStyle(0.5, 0x979797, 1, true, LineScaleMode.NONE);
				drawDottedLine(ptIni, ptEnd)
			} else {
				line.graphics.lineStyle(0.5, 0x979797, 1,true, LineScaleMode.NONE);				
				line.graphics.lineTo(ptEnd.x, ptEnd.y);
			}
		}
		
		private function changeLineStyle(val:int):void {
			return;
			if (_side) {
				if (val == 2) line.graphics.lineStyle(0.5, 0xCCCCCC, 1, true, LineScaleMode.NONE);
				if (val==1) line.graphics.lineStyle(0.5, 0xCCCCCC, 1,true, LineScaleMode.NONE);				
			} else {
				if (val == 2) line.graphics.lineStyle(0.5, 0xCCCCCC, 1, true, LineScaleMode.NONE);
				if (val==1) line.graphics.lineStyle(0.5, 0xCCCCCC, 1,true, LineScaleMode.NONE);								
			}
		}
		
		public function drawDottedLine(ptIni:Point, ptEnd:Point):void {
			var size:int =5;			
			var pEnd:Point;
			var step:Boolean = true;
			var dist:Number = Point.distance(ptIni, ptEnd);
			for (var i:int = 0; i< Math.floor(dist / size); i++) {	
				pEnd = Point.interpolate(ptEnd, ptIni, i / (dist / size))
				if(step){
					line.graphics.lineTo(Math.floor(pEnd.x), Math.floor(pEnd.y));
					step = false;
				} else {
					line.graphics.moveTo(pEnd.x, pEnd.y);
					step = true;
				}				
			}
			
			
			
		}
		
		
		private function onHandlerStartMove(e:MouseEvent):void 
		{
			var handler:Sprite =  Sprite(e.target);
			handler.startDrag(true);
			stage.addEventListener(Event.ENTER_FRAME, onHandlerMoving)
			stage.addEventListener(MouseEvent.MOUSE_UP, onHandlerStopMove)
			
		}
		
		private function onHandlerMoving(e:Event):void 
		{
			drawLine();
		}
		
		private function onHandlerStopMove(e:MouseEvent):void 
		{
			handler1.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onHandlerStopMove);
			stage.removeEventListener(Event.ENTER_FRAME, onHandlerMoving);
		}
		
		
		
		

	}
	
}