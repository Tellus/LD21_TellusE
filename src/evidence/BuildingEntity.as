package evidence 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.*;
	
	/**
	 * A single building, randomly generated.
	 * @author ...
	 */
	public class BuildingEntity extends BaseEntity 
	{
		public function get Surface():Canvas { return graphic as Canvas; }
		public function set Surface(value:Canvas):void { graphic = value; }
		
		public static var MinWidth:int = 25;
		public static var MaxWidth:int = 100;
		
		public static var MinHeight:int = 25;
		public static var MaxHeight:int = 100;
		
		public static const STREET_WIDTH:int = 20;
		
		public var BuildingArea:Rectangle;
		
		public function BuildingEntity(w:int = 0, h:int = 0) 
		{
			if (!w) w = Math.random() * (BuildingEntity.MaxWidth - BuildingEntity.MinWidth) + BuildingEntity.MinWidth;
			if (!h) h = Math.random() * (BuildingEntity.MaxHeight - BuildingEntity.MinHeight) + BuildingEntity.MinHeight;
			
			Surface = new Canvas(w, h);
			Surface.fill(new Rectangle(0, 0, w, h), 0xBBBBBB);
			
			setHitbox(Surface.width, Surface.height);
			
			BuildingArea = new Rectangle(0, 0, width + BuildingEntity.STREET_WIDTH * 2, height + BuildingEntity.STREET_WIDTH * 2);
			
			type = "Building";
		}
		
		override public function render():void 
		{
			// BuildingArea.render();
			
			super.render();
		}
		
		/**
		 * Returns a random point along the edges of the building.
		 * @return A random point that is somewhere along the edge of the building.
		 */
		public function GetRandomEdgePoint():Point
		{
			var p:Point = new Point();
			
			// Randomness #1: work along width sides or height sides?
			if (Math.random() > 0.5)
			{
				// Width sides, variable height.
				p.x = Math.random() > 0.5 ? right + 32 : left - 32;
				p.y = Math.random() * height + y;
			}
			else
			{
				// Height sides, variable width.
				p.y = Math.random() > 0.5 ? bottom + 32 : top - 32;
				p.x = Math.random() * width + x;
			}
			
			return p;
		}
		
		/**
		 * Checks an entity against colliding with the building are.
		 * @param	e	Entity to check against.
		 * @return
		 */
		public function CollideArea(e:Entity):Boolean
		{
			return e.collideRect(e.x, e.y, BuildingArea.x, BuildingArea.y, BuildingArea.width, BuildingArea.height)
		}
		
		/**
		 * Moves a colliding building to the closest edge.
		 * @param	b	The buliding to move.
		 */
		public function RelocateConflict(b:BuildingEntity):void
		{
			// First, we identify which edge the building's center is closest to.
			var offset:Point = new Point(x - b.x, y - b.y); // Although we work with center points, this gives the exact same result for roughly half the processing cost.
			if (Math.max(Math.abs(offset.x), Math.abs(offset.y)) == Math.abs(offset.x))
			{
				// We work with the x axis, either left or right.
				if (offset.x > 0)
				{
					// We work with right.
					// This means moving the building to the right until it's left coordinate
					// matches the right coordinate of this building.
					// There exists no left setter, so we have to calculate this ourselves.
					b.x += b.left - right + STREET_WIDTH;
				}
				else
				{
					// We work with left.
					b.x -= b.right - left - STREET_WIDTH ;
				}
			}
			else
			{
				// We work with the y axis, either top or bottom.
				if (offset.y > 0)
				{
					// We work with bottom.
					b.y += b.top - bottom + STREET_WIDTH ;;
				}
				else
				{
					// We work with top.
					b.y -= b.bottom - top - STREET_WIDTH ;;
				}
			}
			trace("Collision averted.");
		}
		
		override public function moveTo(x:Number, y:Number, solidType:String = null, sweep:Boolean = false):void 
		{
			super.moveTo(x, y, solidType, sweep);
			
			BuildingArea.x = x - STREET_WIDTH;
			BuildingArea.y = y - STREET_WIDTH;
		}
	}
}