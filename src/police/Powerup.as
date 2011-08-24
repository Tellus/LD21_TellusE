package police 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.AngleTween;
	import net.flashpunk.tweens.misc.NumTween;
	/**
	 * Powerups run along the line and come in two flavours:
		 * good - destroys all allegations.
		 * bad - camouflages as good until the player is in range, then shows true colours.
		 * 			Has the same negative effect as hitting allegations.
	 * @author ...
	 */
	public class Powerup extends BaseEntity 
	{
		[Embed(source = '../../img/police/green_powerup.png')] public static const GREEN_SPRITE:Class;
		[Embed(source = '../../img/police/red_powerup.png')] public static const RED_SPRITE:Class;
		
		public static var Risk:Number = 0.5;
		
		/**
		 * The function called by all powerups when they are hit by the player.
		 */
		public static var OnPickedUp:Function = null;
		
		/**
		 * How close the player should be before the cop reveals hisself.
		 */
		public static var DetectionRange:Number = 60;
		
		/**
		 * Time it takes for the powerups to be destroyed.
		 */
		public static var DestroyTime:Number = 0.1;
		
		public var Speed:Number = 1;
		
		public var Bad:Boolean = false;
		
		public var Cloaked:Boolean = false;
		
		protected var TurnTween:AngleTween;
		
		protected var AlphaTween:NumTween;
		
		public var Destroying:Boolean = false;
		
		public function set Img(value:Image):void
		{
			graphic = value as Image;
			(graphic as Image).centerOrigin();
		}
		
		public function get Img():Image { return graphic as Image; }
		
		public function Powerup() 
		{
			// Determine powerup type.
			Bad = Math.random() > Risk;
			if (Bad) Cloaked = true;
			// var c:Class = Math.random() > Risk ? RED_SPRITE : GREEN_SPRITE;
			
			// They always look good :)
			super();
			
			Img = new Image(GREEN_SPRITE);
			
			var g:Image = graphic as Image;
			setHitbox(g.width, g.height);
			
			type = "Powerup";
			
			_createTweens();
		}
		
		private function _createTweens():void
		{
			TurnTween = new AngleTween(OnDestroyed);
			
			addTween(TurnTween, false);
			AlphaTween = new NumTween();
			
			addTween(AlphaTween, false);
		}
		
		public function Destroy():void
		{
			Destroying = true;
			TurnTween.tween(0, 36, DestroyTime);
			TurnTween.start();
			AlphaTween.tween(1, 0, DestroyTime);
			AlphaTween.start();
		}
		
		public function OnDestroyed():void
		{
			world.remove(this);
		}
		
		override public function update():void 
		{
			super.update();
			
			//if (!world) return;
			
			if (AlphaTween.active)
			{
				(graphic as Image).alpha = AlphaTween.value;
				(graphic as Image).angle = TurnTween.angle;
			}
			
			if (Destroying) return;
			
			if (collide("Player", x, y) != null && OnPickedUp != null)
			{
				OnPickedUp.call(this, this);
				Destroy();
			}
			
			var pl:InterrogationCharacter = (world as InterrogationWorld).Player;
			if (Bad && FP.distance(x, y, pl.x, pl.y) < DetectionRange && !AlphaTween.active)
			{
				Img = new Image(RED_SPRITE);
				Cloaked = false;
				Speed += 0.3;
			}
			moveBy( -Speed, 0);
		}
	}
}