package trial 
{
	import dk.homestead.utils.Calc;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * One of the (presumably two...) player's hands. Using either WASD or the arrows
	 * (or, for that matter, anything else) is used to try and move a silhouette hand
	 * closer to the hand proper to stop shaking. The shakes are random jiitters of
	 * location, while the keys are stable counter-movements.
	 * @author ...
	 */
	public class PlayerHand extends BaseEntity 
	{
		[Embed(source = '../../img/trial/hand.png')] public static const HAND_SPRITE:Class;
		
		/**
		 * Highest number of pixels that are jittered randomly every time.
		 */
		public static var MaxJitter:int = 2;
		
		/**
		 * Denotes the hand as a lefty :D
		 */
		public static const LEFTY:int = 0;
		
		/**
		 * Denotes the hand as a righty.
		 */
		public static const RIGHTY:int = 1;
		
		/**
		 * The actual (immovable) hand.
		 */
		public var RealHand:BaseEntity;
		
		/**
		 * Tolerance for the "steady" consideration. This is distance between hand and shade.
		 */
		public var Tolerance:Number = 25;
		
		/**
		 * Random key identifier unique for each hand instance.
		 */
		private var keyId:int = Math.random() * 4000;
		
		public function PlayerHand(X:int = 0, Y:int = 0, handType:int = RIGHTY) 
		{
			super(X, Y, new Image(HAND_SPRITE));
			
			RealHand = new BaseEntity(X, Y, new Image(HAND_SPRITE));
			
			var g:Image = graphic as Image;
			
			g.scale = (RealHand.graphic as Image).scale = Main.GAME_SCALE;
			
			setHitbox(g.width, g.height);
			
			if (handType == LEFTY)
			{
				trace("We got a lefty!");
				g.flipped = true;
				x = RealHand.x = x - width;
			}
			
			g.alpha = 0.4;
		}
		
		/**
		 * Binds keys for this hand instance.
		 * @param	u	Key for moving the hand up.
		 * @param	d	Key for moving the hand down.
		 * @param	l	Key for moving the hand left.
		 * @param	r	Key for moving the hand right.
		 */
		public function SetKeys(u:int, d:int, l:int, r:int):void
		{
			Input.define(keyId + "UP", u);
			Input.define(keyId + "DOWN", d);
			Input.define(keyId + "LEFT", l);
			Input.define(keyId + "RIGHT", r);
		}
		
		public function CheckSteady():Boolean
		{
			return FP.distance(x, y, RealHand.x, RealHand.y) <= Tolerance ? true : false;
		}
		
		override public function render():void 
		{
			RealHand.render();
			
			super.render();
		}
		
		override public function update():void 
		{
			super.update();
			
			RealHand.update();
			
			// Start by defining the movement with the random jitters.
			var moveP:Point = new Point(Calc.RandomSign() * Math.random() * MaxJitter, Calc.RandomSign() * Math.random() * MaxJitter);
			
			if (Input.check(keyId + "UP"))
			{
				moveP.y--;
			}
			if (Input.check(keyId + "DOWN"))
			{
				moveP.y++;
			}
			if (Input.check(keyId + "LEFT"))
			{
				moveP.x--;
			}
			if (Input.check(keyId + "RIGHT"))
			{
				moveP.x++;
			}
			
			moveBy(moveP.x, moveP.y);
		}
	}
}