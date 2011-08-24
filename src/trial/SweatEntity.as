package trial 
{
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * You sweat. And you wipe your brow.
	 * @author ...
	 */
	public class SweatEntity extends BaseEntity 
	{
		[Embed(source = '../../img/trial/droplet.png')] public static var DROP_SPRITE:Class;
		
		/**
		 * Tolerance, percentage, of how much sweat is deemed safe.
		 */
		public var Tolerance:Number = 0.3;
		
		public var Gland:Emitter;
		
		/**
		 * Amount of sweat so far.
		 */
		public var Amount:Number = 0;
		
		/**
		 * Amount of variance for sweating. More sweat means even more sweat even faster.
		 */
		public var SweatAmount:Number = 0.1;
		
		public function SweatEntity() 
		{
			Gland = new Emitter(DROP_SPRITE, 5, 5);
			graphic = Gland;
			Gland.newType("Sweat", new Array(0));
			Gland.setMotion("Sweat", 3, 7, 5);
			
			Input.define("Wipe", Key.SPACE);
		}
		
		public function Wipe():void
		{
			Amount = 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			// trace("Sweat");
			Gland.emit("Sweat", x, y);
			
			if (Input.pressed("Wipe")) Wipe();
			
			Amount += Amount * SweatAmount;
		}
	}

}