package view 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import fl.motion.ITween;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import model.Challenge;
	import model.ChallengeElement;
	import model.Focus;
	import model.Mirror;
	import model.Obj;
	import view.DragHandler;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Scene extends Sprite
	{
		
		private var layerLines:Sprite = new Sprite();
		private var _layerObject:Sprite = new Sprite();
		private var layerChallenge:Sprite = new Sprite();
		private var layerResizer:Sprite = new Sprite();
		private var _mirror:Sprite;
		private var image:Seta;
		private var object:Seta;
		private var focus:SpriteDot;
		private var spriteElement:Sprite;
		private var center:SpriteDot;
		private var element:ChallengeElement;
		private var _scale:Number = 0;
		private var challenge:Challenge;
		private var answerElement:Sprite;
		public function Scene() 
		{
			
		}
		
		public function draw(challenge:Challenge):void {
			this.challenge = challenge;
			layerChallenge.graphics.lineStyle(2, 0x383838);
			
			layerChallenge.graphics.moveTo(0, Config.HEIGHT / 2);
			layerChallenge.graphics.lineTo(Config.WIDTH, Config.HEIGHT / 2);
			addChild(layerChallenge);
			addChild(layerObject);
			addChild(layerLines);						
			addChild(layerResizer);
			setElementsPosition(challenge);
			hideElement();
		}
		
		public function hideElement():void {
			//return;
			if (challenge.element == challenge.image) {
				this.image.alpha = 0;
				answerElement = this.image;
			}
			if (challenge.element == challenge.object) {
				this.object.alpha = 0;
				answerElement = this.object;
			}
			if (challenge.element == challenge.mirror.focus) {
				this.focus.alpha = 0;
				this.center.alpha = 0;
				answerElement = this.focus;
			}			
		}

		
		
		public function calculateScaleFactor(challenge:Challenge):void {
			var minVal:Number = 9999999;
			var maxVal:Number = -999999;			
			minVal = Math.min(challenge.image.distance, challenge.object.distance, challenge.mirror.focus.distance*2);
			maxVal = Math.max(challenge.image.distance, challenge.object.distance, challenge.mirror.focus.distance*2);
			
			var dist:Number = (maxVal + 150) - (minVal - 150); // extra margin
			//dist += (dist * 0.3); //extra margin;
			
			scale = dist / Config.WIDTH;
			//trace("image", challenge.image.distance, "object", challenge.object.distance, "focus", challenge.mirror.focus.distance);
			//trace(dist, scale)
		}
		
		
		
		public function setElementsPosition(challenge:Challenge):void {
			trace(challenge.toString());
			calculateScaleFactor(challenge);
			drawMirror(challenge);
			drawObject(challenge);
			drawFocus(challenge);
			//trace("dist: image", image.x-mirror.x, "object", object.x-mirror.x, "focus", center.x-mirror.x);
			//trace("image", image.x, "object", object.x, "focus", focus.x, "mirror", mirror.x);
			
			var dist:Number = Math.min(image.x, object.x, focus.x, center.x, mirror.x);
			var margin:int = 150;
			image.x -= dist - margin ;
			object.x -= dist - margin ;
			focus.x -= dist - margin ;
			mirror.x -= dist - margin ;
			center.x -= dist - margin ;
			
		}
		
		public function addLine(mx:Number,my:Number):void 
		{
			
			var l:Line = new Line(mirror.x, (challenge.mirror.type==Mirror.CONCAVE?true:false), new Point(mx, my), this);
		}
		
		private function drawFocus(challenge:Challenge):void 
		{
			var inv:int = 1;
			focus = new SpriteDot();
			addChild(focus);
			focus.x = mirror.x + (inv * (challenge.mirror.focus.distance / scale));
			focus.y = Config.HEIGHT / 2;
			
			center = new SpriteDot();
			addChild(center);
			center.x = mirror.x + (inv * ((challenge.mirror.focus.distance * 2) / scale));
			center.y = Config.HEIGHT / 2;
			
			
		}
		
		private function drawObject(challenge:Challenge):void 
		{
			object = new Seta();			
			addChild(object);
			object.x = mirror.x + (challenge.object.distance / scale);
			object.y = Config.HEIGHT / 2;
			
			image = new Seta();			
			addChild(image);
			image.x = mirror.x + (challenge.image.distance / scale);
			
			
			image.y = Config.HEIGHT / 2;
			image.alpha = 0.7
			var scl:Number = challenge.image.size/challenge.object.size
			image.scaleX = scl;
			image.scaleY = scl;
			

			
		}
		
		private function drawMirror(challenge:Challenge):void 
		{
				if (challenge.mirror.type == Mirror.CONCAVE) {
					mirror = new SpriteMirror_Concave();
				} else {
					mirror = new SpriteMirror_Convex();
				}
			
				layerChallenge.addChild(mirror);
				mirror.y = Config.HEIGHT / 2
				mirror.x = (Config.WIDTH / 2) / scale;

				
		}
		
		public function get mirror():Sprite 
		{
			return _mirror;
		}
		
		public function addGhostElement(dh:DragHandler):void {
			layerObject.addChild(dh);
			dh.addEventListener("PositionChanged", onHandlerChanged);
		}

		
		public function receiveElement(handler:DragHandler):void 
		{
			//removeChild(handler);
			spriteElement = Sprite(DragHandler(handler).getIcon());
			if (challenge.element is Focus) {
				var cc:Sprite = new SpriteDot();
				cc.scaleX = spriteElement.scaleX;
				cc.scaleY = spriteElement.scaleY;
				cc.name = "cc";
				spriteElement.addChild(cc);
				cc.x = 0; cc.y = 0;
				
			}
			addChild(spriteElement);
			spriteElement.x = handler.x;
			Actuate.tween(spriteElement, 0.5, { y:Config.HEIGHT / 2 }, true).ease(Elastic.easeInOut).onComplete(createResizer);
			
			layerObject.graphics.clear();
			spriteElement.y = handler.y;
			challenge.hiddenElement.distance = getDistanceFromPosition(spriteElement.x);
			spriteElement.addEventListener(MouseEvent.MOUSE_DOWN, onElementMouseDown);
			challenge.state = Challenge.CHALLENGESTATUS_WAITINGANSWER;


		}
		
		private function createResizer():void {
			adjustCC();
			try {
				layerResizer.removeChildAt(0);	
			} catch (e:Error) {
				
			}
			
			if (spriteElement is Seta && Obj(challenge.element).image) {
				var s:Sprite = new Sprite();
				s.graphics.beginFill(0, 0);
				s.graphics.drawRect( -16,-16,31, 31);
				
				s.graphics.beginFill(0x0000A0);				
				s.graphics.drawRect( -2, -2, 5, 5);
				layerResizer.addChild(s);
				s.name = "resizer"
				s.y = spriteElement.y - spriteElement.height - 5;
				//s.alpha = 0;
				s.x = spriteElement.x;
				
				s.addEventListener(MouseEvent.MOUSE_OVER, onImageResizeOver);
				s.addEventListener(MouseEvent.MOUSE_OUT, onImageResizeOut);
				s.addEventListener(MouseEvent.MOUSE_DOWN, onImageResizerMouseDown);
			}			
		}
		
		private var ypos_mouse:int = 0;
		private var ypos_img:int = 0;
		private function onImageResizerMouseDown(e:MouseEvent):void 
		{
			ypos_mouse = mouseY;
			ypos_img = e.target.y;
			Sprite(e.target).addEventListener(Event.ENTER_FRAME, onImageResizerEnterFrame)
			stage.addEventListener(MouseEvent.MOUSE_UP, onImageResizerMouseUp)
		}
		
		private function onImageResizerMouseUp(e:MouseEvent):void 
		{
			layerResizer.getChildByName("resizer").removeEventListener(Event.ENTER_FRAME, onImageResizerEnterFrame)
			stage.removeEventListener(MouseEvent.MOUSE_UP, onImageResizerMouseUp)			
		}
		
		private function onImageResizerEnterFrame(e:Event):void 
		{
				e.target.y = (ypos_img + (mouseY - ypos_mouse));
				var alt:int = (Config.HEIGHT/2 - e.target.y) - 5 * (e.target.y>Config.HEIGHT/2?-1:1);
				var r:Number = alt / object.height;
				spriteElement.scaleY = alt / object.height
				spriteElement.scaleX = alt/ object.height
				var sz:Number = challenge.object.size * r;
				trace(alt);
				trace(challenge.object.size, challenge.image.size, sz);
				challenge.hiddenElement.size = sz;
				challenge.hiddenElement.inverted = (alt < 0);
				
				
				
		}
		
		private var intoresizer:Boolean = false;
		private function onImageResizeOver(e:MouseEvent):void 
		{
			if (intoresizer == true) return;
			intoresizer = true;
			Actuate.tween(e.target, 1, { alpha:1 }, true);
			
		}

		private function onImageResizeOut(e:MouseEvent):void 
		{
			if (intoresizer == false) return;
			intoresizer = false;
			Actuate.tween(e.target, 1, { alpha:0.03 }, true);
			
		}		
		private function onElementMouseDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onElementMouseUp)
			spriteElement.addEventListener(Event.ENTER_FRAME, onElementMove);
		}
		
		private function onElementMove(e:Event):void 
		{
			spriteElement.x = mouseX;
			if(layerResizer.getChildByName("resizer")!=null) layerResizer.getChildByName("resizer").x = mouseX;
			adjustCC()
			//challenge.hiddenElement.inverted = (mouseY > Config.HEIGHT / 2);				
			//if (challenge.hiddenElement.inverted) {
//				spriteElement.rotationX = 180
			//} else {
//				spriteElement.rotationX = 0;
			//}
		}
		
		private function adjustCC():void 
		{
			if (challenge.element is Focus) {
				spriteElement.getChildByName("cc").x = spriteElement.globalToLocal(new Point(spriteElement.x - (mirror.x - spriteElement.x), 0)).x;				
			}			
		}
		
		private function onElementMouseUp(e:MouseEvent):void 
		{
			spriteElement.removeEventListener(Event.ENTER_FRAME, onElementMove);
			challenge.hiddenElement.distance = getDistanceFromPosition(spriteElement.x);
			
			
		}
		
		
		
		
		private function onHandlerChanged(e:Event):void 
		{
			layerObject.graphics.clear();
			var dh:DragHandler = DragHandler(e.target);
			layerObject.graphics.lineStyle(1, 0x008080, 0.8);
			layerObject.graphics.moveTo(dh.x, dh.y);
			layerObject.graphics.lineTo(dh.x, Config.HEIGHT / 2);
			
			
		}
		
		
		public function getDistanceFromPosition(x:Number):Number {
			
			var dMin:Number = Math.min(image.x, object.x, focus.x, center.x, mirror.x);
			var margin:int = 150;
			var xMirror:Number = mirror.x;
			var d:Number =  scale * (x + dMin - margin - xMirror)
			return d;
		}		
		
		public function showAnswer(viewAnswer:Boolean):void 
		{
			if (viewAnswer) {
				Actuate.tween(spriteElement, 1, { alpha:0 } ) ;
				Actuate.tween(answerElement, 1, { alpha:1 } ) ;	
				if (challenge.element == challenge.mirror.focus) {				
					Actuate.tween(center, 1, { alpha:1 } ) ;
				}
			} else {
				Actuate.tween(spriteElement, 1, { alpha:1 } ) ;
				Actuate.tween(answerElement, 1, { alpha:0 } ) ;	
				if (challenge.element == challenge.mirror.focus) {				
					Actuate.tween(center, 1, { alpha:0 } ) ;
				}				
			}
			
		}
				
		public function set mirror(value:Sprite):void 
		{
			_mirror = value;
		}
		
		public function get layerObject():Sprite 
		{
			return _layerObject;
		}
		
		public function set layerObject(value:Sprite):void 
		{
			_layerObject = value;
		}
		
		public function get scale():Number 
		{
			return _scale;
		}

		public function set scale(value:Number):void 
		{
			_scale = value;
		}
		
		
		
	}
	
}