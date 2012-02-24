package view 
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			handler2.x = _startPoint.x + 20;
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
			var pos:Number = (_xposition - pt0.x) / (pt1.x - pt0.x);
			centralPoint = Point.interpolate(new Point(pt1.x, pt1.y), new Point(pt0.x, pt0.y), pos);			
			line.graphics.clear();
			line.graphics.moveTo(pt0.x, pt0.y)			
			line.graphics.lineStyle(1, 0, 1);			
			//line.graphics.lineGradientStyle(GradientType.LINEAR, [0, 1, 0, 1, 0, 1], [1, 1, 1, 1, 1, 1], [255 / 6, 255*2 / 6, 255*3 / 6, 255*4 / 6, 255*5 / 6, 255*6 / 6]) 
			line.graphics.lineTo(centralPoint.x, centralPoint.y);
			line.graphics.lineStyle(1, 0x008040, 1);			
			line.graphics.lineTo(pt1.x, pt1.y);
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