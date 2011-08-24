package evidence 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * Active player. Simple WASD movement.
	 * @author Johannes L. Borresen
	 */
	public class Character extends BaseEntity 
	{
		[Embed(source = '../../img/evidence/player.png')] public static const PLAYER_SPRITE:Class;
		
		public var Speed:Number = 2.7;
		
		public function Character() 
		{
			graphic = new Image(PLAYER_SPRITE);
			
			var i:Image = graphic as Image;
			
			setHitbox(i.width, i.height);
			
			type = "Player";
		}
		
		override public function update():void 
		{
			super.update();
			
			var moveP:Point = new Point();
			if (Input.check("LEFT"))
			{
				moveP.x -= Speed;
			}
			if (Input.check("RIGHT"))
			{
				moveP.x += Speed;
			}
			if (Input.check("UP"))
			{
				moveP.y -= Speed;
			}
			if (Input.check("DOWN"))
			{
				moveP.y += Speed;
			}
			
			moveBy(moveP.x, moveP.y, "Building", true);
		}
	}
}