package police 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author ...
	 */
	public class InterrogationCharacter extends BaseEntity 
	{
		[Embed(source = '../../img/police/you.png')] public static const PLAYER_SPRITE:Class;
		
		public var Speed:Number = 3;
		
		public function get Img():Image { return graphic as Image; }
		public function set Img(value:Image):void { graphic = value; }
		
		/**
		 * Highest x allowed for the character.
		 */
		public var MaxX:int;
		
		/**
		 * Highest y allowed for the character.
		 */
		public var MaxY:int;
		
		/**
		 * Lowest x allowed for characters.
		 */
		public var MinX:int;
		
		/**
		 * Lowest y allowed for characters.
		 */
		public var MinY:int;
		
		public function InterrogationCharacter() 
		{
			super(0, 0, new Image(PLAYER_SPRITE));

			setHitbox(Img.width, Img.height);
			
			type = "Player";
			
			graphic.scrollX = 1;
		}
		
		public function SetBoundaries(minX:int, minY:int, maxX:int, maxY:int):void
		{
			MinX = minX;
			MinY = minY;
			MaxX = maxX;
			MaxY = maxY;
		}
		
		override public function update():void 
		{
			super.update();
			
			var moveP:Point = new Point();
						
			if (Input.check("DOWN") && y + height < MaxY)
			{
				moveP.y += Speed;
			}
			if (Input.check("UP") && y > MinY)
			{
				moveP.y -= Speed;
			}
			if (Input.check("LEFT") && x > FP.camera.x)
			{
				moveP.x -= Speed;
			}
			if (Input.check("RIGHT") && x < (FP.camera.x + FP.width - width))
			{
				moveP.x += Speed;
			}
			
			moveBy(moveP.x, moveP.y, "Block", true);
			
			if (x < FP.camera.x) x = FP.camera.x;
		}
	}
}