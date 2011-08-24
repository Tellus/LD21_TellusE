package evidence 
{
	import dk.homestead.utils.Data;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * The hiding spot is where you can hide a piece of loot.
	 * @author ...
	 */
	public class HidingSpotEntity extends BaseEntity 
	{
		[Embed(source = '../../img/evidence/hidingSpot.png')] public static const HIDING_SPOT_SPRITE:Class;
		
		/**
		 * Is this spot already taken?
		 */
		public var Used:Boolean = false;
		
		public function HidingSpotEntity() 
		{
			super(0, 0, new Spritemap(HIDING_SPOT_SPRITE, 25, 25));
			
			type = "HidingPlace";
			
			var g:Spritemap = graphic as Spritemap;
			setHitbox(g.width, g.height);
			g.add("go", Data.FillArray(g.frameCount), 10, true);
			g.play("go", true);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!Used && collide("Player", x, y) != null)
			{
				Used = true;
				
				(graphic as Spritemap).frame = 0;
				
				(graphic as Spritemap).alpha = 0.3;
				(graphic as Spritemap).color = 0xAAAAAA;
				(world as EvidenceWorld).OnLootDropped(this);
			}
		}
	}
}