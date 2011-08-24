package  
{
	import flash.geom.Point;
	import net.flashpunk.*;
	
	/**
	 * Proxy for some stuff I need that just simplifies code for me.
	 * @author ...
	 */
	public class BaseEntity extends Entity 
	{
		/**
		 * Center of the entity. Good since I use lots of points, unlike FlashPunk.
		 */
		public function get Center():Point
		{
			return new Point(centerX, centerY);
		}
		
		/**
		 * Center of the entity. Good since I use lots of points, unlike FlashPunk.
		 */
		public function set Center(value:Point):void
		{
			x = value.x - halfWidth;
			y = value.y - halfHeight;
		}
		
		public function BaseEntity(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null) 
		{
			super(x, y, graphic, mask);
		}
	}
}