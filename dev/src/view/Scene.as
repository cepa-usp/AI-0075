package view 
{
	import fl.motion.ITween;
	import flash.display.Sprite;
	import flash.geom.Point;
	import model.Challenge;
	import model.ChallengeElement;
	import model.Mirror;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Scene extends Sprite
	{
		
		private var layerLines:Sprite = new Sprite();
		private var layerChallenge:Sprite = new Sprite();
		private var _mirror:Sprite;
		private var image:SpriteArrow;
		private var object:SpriteArrow;
		private var focus:SpriteDot;
		private var center:SpriteDot;
		private var element:ChallengeElement;
		private var scale:Number = 0;
		
		public function Scene() 
		{
			
		}
		
		public function draw(challenge:Challenge):void {
			layerChallenge.graphics.lineStyle(2, 0x383838);
			layerChallenge.graphics.moveTo(0, Config.HEIGHT / 2);
			layerChallenge.graphics.lineTo(Config.WIDTH, Config.HEIGHT / 2);
			addChild(layerChallenge);
			addChild(layerLines);			
			setElementsPosition(challenge);
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
			var l:Line = new Line(mirror.x, true, new Point(mx, my), this);
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
			object = new SpriteArrow();			
			addChild(object);
			object.x = mirror.x + (challenge.object.distance / scale);
			object.y = Config.HEIGHT / 2;
			
			image = new SpriteArrow();			
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
		
		public function set mirror(value:Sprite):void 
		{
			_mirror = value;
		}
		
		
		
	}
	
}